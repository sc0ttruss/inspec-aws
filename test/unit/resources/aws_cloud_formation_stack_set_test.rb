require 'helper'
require 'aws_cloud_formation_stack_set'
require 'aws-sdk-core'

class AWSCloudFormationStackSetConstructorTest < Minitest::Test

  def test_empty_params_ok
    AWSCloudFormationStackSet.new(client_args: { stub_responses: true })
  end

  def test_rejects_other_args
    assert_raises(ArgumentError) { AWSCloudFormationStackSet.new('rubbish') }
  end

  def test_job_definitions_non_existing_for_empty_response
    refute AWSCloudFormationStackSet.new(client_args: { stub_responses: true }).exist?
  end
end

class AWSCloudFormationStackSetHappyPathTest < Minitest::Test

  def setup
    data = {}
    data[:method] = :describe_stack_set
    mock_parameter = {}
    mock_parameter[:stack_set_name] = 'test1'
    mock_parameter[:stack_set_id] = 'test1'
    mock_parameter[:etag] = 'test1'
    data[:data] = { stack_set: [mock_parameter] }
    data[:client] = Aws::CloudFormation::Client
    @stack_set = AWSCloudFormationStackSet.new(id: 'test1', client_args: { stub_responses: true }, stub_data: [data])
  end

  def stack_set_exists
    assert @stack_set.exists?
  end

  def test_stack_set_id
    assert_equal(@stack_set.stack_set_name, test1)
  end

  def test_stack_set_etag
    assert_equal(@stack_set.stack_set_id, test1)
  end
end