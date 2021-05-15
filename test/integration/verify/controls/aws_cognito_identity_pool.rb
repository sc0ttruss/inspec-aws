aws_identity_pool_id = attribute("aws_identity_pool_id", default: "us-east-2:4cb6caa6-7f46-4aa8-9a75-f9fdd2024009", description: "")
aws_identity_pool_name = attribute("aws_identity_pool_name", default: "test1", description: "")
aws_allow_unauthenticated_identities = attribute("aws_allow_unauthenticated_identities", default: true, description: "")
aws_allow_classic_flow = attribute("aws_allow_classic_flow", default: true, description: "")
aws_supported_login_providers = attribute("aws_supported_login_providers", default: "", description: "")
aws_developer_provider_name = attribute("aws_developer_provider_name", default: "", description: "")
aws_cognito_identity_providers = attribute("aws_cognito_identity_providers", default: "", description: "")
aws_saml_provider_arns = attribute("aws_saml_provider_arns", default: "", description: "")
identity_pool_tags = attribute("aws_cognito_identity_providers", default: "", description: "")

describe aws_cognito_identity_pool(identity_pool_id: aws_identity_pool_id) do
  it { should exist }
  its('identity_pool_id') { should eq aws_identity_pool_id }
  its('identity_pool_name') { should eq aws_identity_pool_name }
  its('allow_unauthenticated_identities') { should eq aws_allow_unauthenticated_identities }
  its('allow_classic_flow') { should eq aws_allow_classic_flow }
  its('supported_login_providers') { should be_empty }
  its('developer_provider_name') { should be_empty }
  its('open_id_connect_provider_arns') { should be_empty }
  its('cognito_identity_providers') { should_not be_empty }
  its('saml_provider_arns') { should be_empty }
  its('identity_pool_tags') { should be_empty }
end