# frozen_string_literal: true

require 'aws_backend'

class AWSApiGatewayAuthorizer < AwsResourceBase
  name 'aws_apigateway_authorizer'
  desc 'Describe an existing Authorizer resource.'
  example "
    describe aws_apigateway_authorizer(rest_api_id: 'REST_API_ID', authorizer_id: 'REST_API_AUTHORIZER_ID') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    opts = { api_id: opts } if opts.is_a?(String)
    opts = { authorizer_id: opts } if opts.is_a?(String)
    super(opts)
    validate_parameters(required: %i(rest_api_id authorizer_id))
    raise ArgumentError, "#{@__resource_name__}: rest_api_id must be provided" unless opts[:rest_api_id] && !opts[:rest_api_id].empty?
    raise ArgumentError, "#{@__resource_name__}: authorizer_id must be provided" unless opts[:authorizer_id] && !opts[:authorizer_id].empty?
    @display_name = opts[:authorizer_id]
    catch_aws_errors do
      resp = @aws.apigateway_client.get_authorizer({ rest_api_id: opts[:rest_api_id], authorizer_id: opts[:authorizer_id] })
      @res = resp.to_h
      create_resource_methods(@res)
    end
  end

  def authorizer_id
    return nil unless exists?
    @res[:authorizer_id]
  end

  def exists?
    !@res.nil? && !@res.empty?
  end

  def to_s
    "Rest API Authorizer ID: #{@display_name}"
  end
end
