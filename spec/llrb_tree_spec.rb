require 'spec_helper'

describe IntervalrSupport::LlrbTree do
  KEY_COUNT = 10000

  subject do
    described_class.new
  end

  def key_generator
    Random.rand 0...KEY_COUNT
  end

  let(:keys) do
    keys = {}
    KEY_COUNT.times do
      keys[key_generator] = true
    end
    keys.keys
  end

  let(:mixed_keys) do
    keys.sort_by { Random.rand }
  end

  it 'should be able to insert nodes' do
    expected_tree_size = 0
    keys.each do |key|
      subject[key] = key
      expected_tree_size += 1
    end

    subject.size.should equal(expected_tree_size)
  end

  context 'when it has nodes' do
    before(:each) do
      keys.each do |key|
        subject[key] = key
      end
    end

    it 'should not be able to insert duplicate nodes' do
      expected_tree_size = subject.size

      mixed_keys.each do |key|
        subject[key] = key
      end

      subject.size.should equal(expected_tree_size)
    end

    it 'should be able to find a node' do
      mixed_keys.each do |key|
        subject[key].should equal(key)
      end
    end

    it 'should be able to delete a node' do
      keys.each do |key|
        subject.delete key
      end

      subject.size.should equal(0)
    end
  end
end