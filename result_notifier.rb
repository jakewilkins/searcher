require 'mailgun'
require 'erb'

class ResultNotifier
  TEMPLATE_PATH = Pathname.new(__FILE__).dirname.join('email.erb')
  MAILGUN_DOMAIN = ENV.fetch('MAILGUN_DOMAIN')

  def self.call(updates)
    new(updates).call
  end
  attr_reader :updates

  def initialize(updates)
    @updates = updates
  end

  def call
    updates.each do |email_data|
      html = ERB.new(email_template).result(binding)
      text = build_text_string(email_data)
      subj = "[#{email_data.search_names}] #{email_data.result_count} New Results"
      send_email(email_data.person, subj, html, text)
      email_data.notified!
    end
  end

  private

  def send_email(subscriber, subj, html, text)
    msg = Mailgun::MessageBuilder.new
    msg.from(ENV['NOTIFIER_FROM'], {"first"=>"Craigslist", "last" => "Searcher"})
    msg.add_recipient(:to, subscriber.email, {'first' => subscriber.name})
    msg.subject(subj)
    msg.body_text(text)
    msg.body_html(html)

    mailgun.send_message(MAILGUN_DOMAIN, msg)
  end

  def build_text_string(reses)
  end

  def email_template
    @template ||= File.read(TEMPLATE_PATH)
  end

  def mailgun
    @mailgun ||= Mailgun::Client.new(ENV.fetch('MAILGUN_API_KEY'))
  end
end
