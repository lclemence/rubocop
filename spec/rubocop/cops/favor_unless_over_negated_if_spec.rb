# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    describe FavorUnlessOverNegatedIf do
      let (:fav_unless) { FavorUnlessOverNegatedIf.new }

      it 'registers an offence for if with exclamation point condition' do
        inspect_source(fav_unless, 'file.rb',
                       ['if !a_condition',
                        '  some_method',
                        'end',
                        'some_method if !a_condition',
                       ])
        fav_unless.offences.map(&:message).should ==
          ['Favor unless (or control flow or) over if for negative ' +
           'conditions.'] * 2
      end

      it 'registers an offence for if with "not" condition' do
        inspect_source(fav_unless, 'file.rb',
                       ['if not a_condition',
                        '  some_method',
                        'end',
                        'some_method if not a_condition'])
        fav_unless.offences.map(&:message).should ==
          ['Favor unless (or control flow or) over if for negative ' +
           'conditions.'] * 2
        fav_unless.offences.map(&:line_number).should == [1, 4]
      end

      it 'accepts an if/else with negative condition' do
        inspect_source(fav_unless, 'file.rb',
                       ['if !a_condition',
                        '  some_method',
                        'else',
                        '  something_else',
                        'end',
                        'if not a_condition',
                        '  some_method',
                        'elsif other_condition',
                        '  something_else',
                        'end'])
        fav_unless.offences.map(&:message).should == []
      end

      it 'accepts an if where only part of the contition is negated' do
        inspect_source(fav_unless, 'file.rb',
                       ['if !a_condition && another_condition',
                        '  some_method',
                        'end',
                        'if not a_condition or another_condition',
                        '  some_method',
                        'end',
                        'some_method if not a_condition or another_condition'])
        fav_unless.offences.map(&:message).should == []
      end
    end
  end
end
