class X::MassPublisherService < BaseService
  def call(search, topic)
    payload = X::TweetGeneratorService.new(topic).call
    logger.info(payload)
    X::TweetsReplierService.new(search, payload).call
  end
end
