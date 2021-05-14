require 'bundler/setup'
require 'pry-byebug'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'slack-ruby-client'

constellations = [
  "aries",
  "taurus",
  "gemini",
  "cancer",
  "leo",
  "virgo",
  "libra",
  "scorpio",
  "sagittarius",
  "capricorn",
  "aquarius",
  "pisces"
]

constellations_kana = [
  "【おひつじ座】",
  "【おうし座】",
  "【ふたご座】",
  "【かに座】",
  "【しし座】",
  "【おとめ座】",
  "【てんびん座】",
  "【さそり座】",
  "【いて座】",
  "【やぎ座】",
  "【みずがめ座】",
  "【うお座】"
]

Slack.configure do |config|
  config.token = ENV['BOT_USER_ACCESS_TOKEN']
end

base_url = "https://voguegirl.jp/horoscope/shiitake/"
date = Date.today
client = Slack::Web::Client.new

constellations.zip(constellations_kana) do |constellation, constellation_kana|
  url = base_url + constellation + "/" + date.strftime("%Y%m%d") + "/"
  doc = Nokogiri::HTML(URI.open(url))
  text = doc.xpath('//div[@class="a-text"]')[0].text
  post_text = constellation_kana + "\n\n" + text.strip + "\n\n続きはこちら⇒ " + url
  client.chat_postMessage(
    channel: '第二期成長計画',
    text: post_text
  )
end