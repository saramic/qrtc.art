class Feature
  FEATURES = [
    "new-page",
  ].freeze

  def self.validate_feature!(feature_name)
    raise ArgumentError, "feature is NOT valid #{feature_name.inspect}" unless FEATURES.include?(feature_name)
  end
end
