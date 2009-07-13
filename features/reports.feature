@reports
Feature: Correctly formatted reports
  In order to get the most out of reek
  As a developer
  I want to be able to parse reek's output simply and consistently

  Scenario: two reports run together with indented smells
    When I run reek spec/samples/two_smelly_files/*.rb
    Then it fails with exit status 2
    And it reports:
      """
      spec/samples/two_smelly_files/dirty_one.rb -- 6 warnings:
        Dirty has the variable name '@s' (Uncommunicative Name)
        Dirty#a calls @s.title multiple times (Duplication)
        Dirty#a calls puts(@s.title) multiple times (Duplication)
        Dirty#a has the name 'a' (Uncommunicative Name)
        Dirty#a/block has the variable name 'x' (Uncommunicative Name)
        Dirty#a/block/block is nested (Nested Iterators)
      spec/samples/two_smelly_files/dirty_two.rb -- 6 warnings:
        Dirty has the variable name '@s' (Uncommunicative Name)
        Dirty#a calls @s.title multiple times (Duplication)
        Dirty#a calls puts(@s.title) multiple times (Duplication)
        Dirty#a has the name 'a' (Uncommunicative Name)
        Dirty#a/block has the variable name 'x' (Uncommunicative Name)
        Dirty#a/block/block is nested (Nested Iterators)

      """

  Scenario: good files show headers consecutively
    When I run reek spec/samples/three_clean_files/*.rb
    Then it succeeds
    And it reports:
      """
      spec/samples/three_clean_files/clean_one.rb -- 0 warnings
      spec/samples/three_clean_files/clean_three.rb -- 0 warnings
      spec/samples/three_clean_files/clean_two.rb -- 0 warnings

      """

  Scenario Outline: --quiet turns off headers for fragrant files
    When I run reek <option> spec/samples/three_clean_files/*.rb
    Then it succeeds
    And it reports:
      """


      """

    Examples:
      | option  |
      | -q      |
      | --quiet |


  Scenario Outline: -a turns on details in presence of -q
    When I run reek <options> spec/samples/clean_due_to_masking/*.rb
    Then it succeeds
    And it reports:
      """
      spec/samples/clean_due_to_masking/dirty_one.rb -- 0 warnings (+6 masked):
        (masked) Dirty has the variable name '@s' (Uncommunicative Name)
        (masked) Dirty#a calls @s.title multiple times (Duplication)
        (masked) Dirty#a calls puts(@s.title) multiple times (Duplication)
        (masked) Dirty#a has the name 'a' (Uncommunicative Name)
        (masked) Dirty#a/block has the variable name 'x' (Uncommunicative Name)
        (masked) Dirty#a/block/block is nested (Nested Iterators)
      spec/samples/clean_due_to_masking/dirty_two.rb -- 0 warnings (+6 masked):
        (masked) Dirty has the variable name '@s' (Uncommunicative Name)
        (masked) Dirty#a calls @s.title multiple times (Duplication)
        (masked) Dirty#a calls puts(@s.title) multiple times (Duplication)
        (masked) Dirty#a has the name 'a' (Uncommunicative Name)
        (masked) Dirty#a/block has the variable name 'x' (Uncommunicative Name)
        (masked) Dirty#a/block/block is nested (Nested Iterators)

      """

    Examples:
      | options  |
      | -q -a    |
      | -a -q    |
