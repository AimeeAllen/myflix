require 'spec_helper'

describe User do
  it {should have_many(:reviews)}
  it {should have_many(:queue_items)}
  it {should have_many(:videos).through(:queue_items)}
end
