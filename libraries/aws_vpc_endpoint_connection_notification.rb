# frozen_string_literal: true

require 'aws_backend'

class AwsVpcEndpointConnectionNotification < AwsResourceBase
  name 'aws_vpc_endpoint_connection_notification'
  desc 'Verifies settings for an AWS VPC Endpoint Notification.'
  example "
    describe aws_vpc_endpoint_connection_notification(connection_notification_id: 'VPC_ENDPOINT_CONNECTION_NOTIFICATION_ID') do
      it { should exist }
    end
    describe aws_vpc_endpoint_connection_notification('VPC_ENDPOINT_CONNECTION_NOTIFICATION_ID') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    opts = { connection_notification_id: opts } if opts.is_a?(String)
    super(opts)
    validate_parameters(required: [:connection_notification_id])

    if opts[:connection_notification_id] !~ /(^vpce-nfn-[0-9a-f]{17}$)|(^vpce-nfn\-[0-9a-f]{8}$)/
      raise ArgumentError, "#{@__resource_name__}: 'connection_notification_id' must be in the format 'vpce-nfn-' followed by 8  or 17 hexadecimal characters."
    end

    @display_name = opts[:connection_notification_id]
    req_param = { connection_notification_id: opts[:connection_notification_id] }
    catch_aws_errors do
      resp = @aws.compute_client.describe_vpc_endpoint_connection_notifications(req_param)
      @vpcen = resp.connection_notification_set[0].to_h
      create_resource_methods(@vpcen)
    end
  end

  def exists?
    !@vpcen.nil? && !@vpcen.empty?
  end

  def connection_notification_state_enabled?
    @vpcen[:connection_notification_state]=='Enabled'
  end

  def to_s
    "VPC Endpoint Connection Notification ID: #{@display_name}"
  end
end
