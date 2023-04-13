self: super:

{
  # Provide the custom-built jaraco.services package
  jaraco_services = super.jaraco_services.overrideAttrs (oldAttrs: rec {
    pname = "jaraco.services";
    version = "3.1.0";

    # ... other customizations as needed
  });

  # Use the custom-built jaraco.services package in jaraco.mongodb
  jaraco_mongodb = super.jaraco_mongodb.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
      ++ [ self.jaraco_services ];
  });
}
