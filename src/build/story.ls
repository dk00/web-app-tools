function story description, fn
  describe description, ->
    fn ({given, should, actual, expected}) ->
      test "Given #{given}: should #{should}" ->
        expect actual .to-be expected

export default: story
