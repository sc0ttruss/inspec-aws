# frozen_string_literal: true

require 'aws_backend'

class AWSElasticLoadBalancingV2ListenerRule < AwsResourceBase
  name 'aws_elasticloadbalancingv2_listener_rule'
  desc 'Describes the specified rules or the rules for the specified listener. You must specify either a listener or one or more rules.'

  example "
    describe aws_elasticloadbalancingv2_listener_rule(rule_arn: 'test') do
      it { should exist }
    end
  "
  def initialize(opts = {})
    opts = { rule_arns: opts } if opts.is_a?(String)
    super(opts)
    validate_parameters(required: [:rule_arn])
    raise ArgumentError, "#{@__resource_name__}: rule_arns must be provided" unless opts[:rule_arn] && !opts[:rule_arn].empty?
    @display_name = opts[:rule_arn]
    catch_aws_errors do
      resp = @aws.elb_client_v2.describe_rules({ rule_arns: [opts[:rule_arn]] })
      @listeners = resp.rules[0].to_h
      create_resource_methods(@listeners)
    end
  end

  def id
    return nil unless exists?
    @listeners[:listener_arns]
  end

  def exists?
    !@listeners.nil? && !@listeners.empty?
  end

  def encrypted?
    @listeners[:encrypted]
  end

  def to_s
    "listener_arns: #{@display_name}"
  end
end
