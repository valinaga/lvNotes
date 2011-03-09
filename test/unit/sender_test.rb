require 'test_helper'

class SenderTest < ActiveSupport::TestCase
  
  test "sender not empty" do
    sender = Sender.new
    assert sender.invalid?, "nil sender should be invalid"
    assert sender.errors[:first_name].any?, "first name should not be empty" 
    assert sender.errors[:last_name].any?, "last name should not be empty"
    assert sender.errors[:email].any?, "email should not be empty"
    assert sender.errors[:password].any?, "password should not be empty" 
  end
  
  def new_sender(name,lname,email)
    Sender.new(:first_name => name,
               :last_name => lname,
               :password => 'pass',
               :email => email)
  end
  
  test "sender has a valid e-mail" do
    ok = %W{ ion@balon.com
             aurel.vlaicu@aure.vlaicu.co.uk
             maricel_patrunjel@m-p.co.uk
             tankuri!T34@[192.168.1.2]
             mos.craciun#mail@primaria-brasov.bv.ro
             12carctere$d%l&o'd*a+p-s/a=?^`{|}~d3@coolmail.dot}
    bad = %W{ "mos\ ion"@mail.com
              alex.lapusneanu@palat
              dima..cantemir@histo.fr
              nu_mai_am_adrese@domeniu.e
              arond@arond@mail.com
              .punct@mail.com
              altpunct.@mail.com
              @mail.com
              iarpunct@mail.com.
              caractere%d(d)l[s]a\a,dq>e<s@carac.com
              demoniuinvalid@s!#~`$%^&*()+=\|{}]["':;/?><,.com              
            }
    ok.each do |t|
      assert new_sender('nume', 'prenume', t).valid?, "#{t} should be ok"
    end
    
    bad.each do |t|
      assert new_sender('nume', 'preume', t).invalid?, "#{t} should be invalid"
    end
  end
  
  test "sender has a valid name" do
    ok = %w{ ion
             maria
             ana-maria
             ana maria
             john al 3-lea
           }
    bad = %W{ i
              ~`!@#)({}[]\|"':;/?.,><+=-_1234567890
            }
    ok.each do |t|
      assert new_sender(t, 'prenume', 'email@domeniu.com').valid?, "#{t} name should be ok"
      assert new_sender('nume', t, 'email@domeniu.com').valid?, "#{t} last name should be ok"
    end
    
    bad.each do |t|
      assert new_sender(t, 'prenume', 'email@domeniu.com').invalid?, "#{t} name shoul be invalid"
      assert new_sender('nume', t, 'email@domeniu.com').invalid?, "#{t} last name shoul be invalid"
    end
  end
end
