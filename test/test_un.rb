dir = File.expand_path "~/.ruby_inline"
if test ?d, dir then
  require 'fileutils'
  puts "nuking #{dir}"
  # force removal, Windoze is bitching at me, something to hunt later...
  FileUtils.rm_r dir, :force => true
end

require 'test/unit'
require 'un'

class Man
  def strength
    10
  end
end

class Machine; end

module SuperDuper
  def strength
    11
  end
end

class TestUn < Test::Unit::TestCase
  def test_unextend
    man = Man.new
    assert_equal 10, man.strength

    man.extend SuperDuper

    assert_equal 11, man.strength
    assert man.kind_of?(SuperDuper)

    man.unextend SuperDuper

    assert_equal 10, man.strength
    assert ! man.kind_of?(SuperDuper) # FIX
  end

  def test_uninclude
    machine = Machine.new

    assert_raises NoMethodError do
      machine.strength
    end

    Machine.send :include, SuperDuper

    assert_equal 11, machine.strength
    assert_kind_of SuperDuper, machine

    Machine.send :uninclude, SuperDuper

    assert_raises NoMethodError do
      machine.strength
    end
  end
end
