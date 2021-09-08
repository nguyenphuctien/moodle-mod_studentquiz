@mod @mod_studentquiz
Feature: Create comment as an user
  In order to join the comment area
  As a user
  I need to be able to create comment

  Background:
    # 'I set the field' doesn't work on Moodle <= 35
    Given I make sure the current Moodle branch is greater or equal "36"
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher  | The       | Teacher  | teacher1@example.com |
      | student1 | Student   | One      | student1@example.com |
      | student2 | Alex      | Dan      | student2@example.com |
      | student3 | Chris     | Bron     | student3@example.com |
      | student4 | Danny     | Civi     | student4@example.com |
      | student5 | Bob       | Alex     | student5@example.com |
      | student6 | James     | Potter   | student6@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher  | C1     | editingteacher |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
      | student3 | C1     | student        |
      | student4 | C1     | student        |
      | student5 | C1     | student        |
      | student6 | C1     | student        |
    And the following "activities" exist:
      | activity    | name          | intro              | course | idnumber     | forcecommenting | publishnewquestion | anonymrank |
      | studentquiz | StudentQuiz 1 | Quiz 1 description | C1     | studentquiz1 | 1               | 1                  | 0          |
      | studentquiz | StudentQuiz 2 | Quiz 2 description | C1     | studentquiz2 | 1               | 1                  | 1          |
    And the following "questions" exist:
      | questioncategory          | qtype     | name                          | questiontext          |
      | Default for StudentQuiz 1 | truefalse | Test question to be previewed | Answer the question 1 |
      | Default for StudentQuiz 2 | truefalse | Test question to be previewed | Answer the question 2 |

  @javascript
  Scenario: Admin and user can sortable.
    # Student 2
    When I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "student2"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I enter the text "Comment 2" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I log out
    # Student 3
    And I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "student3"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I enter the text "Comment 3" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I log out
    # Student 4
    And I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "student4"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I enter the text "Comment 4" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I log out
    # Student 5
    And I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "student5"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I enter the text "Comment 5" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I log out
    # Student 6
    And I log in as "student6"
    And I am on "Course 1" course homepage
    And I follow "StudentQuiz 1"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I enter the text "Comment 6" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I enter the text "Comment 7" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I log out
    # Log in as admin
    And I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "admin"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    # Sort Date DESC (Default is Date ASC).
    And I click on "Date" "link" in the ".studentquiz-comment-filters" "css_element"
    # Prevent behat fails (even single run is fine).
    And I wait until the page is ready
    Then I should see "Comment 7" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    And I should see "Comment 6" in the ".studentquiz-comment-item:nth-child(2) .studentquiz-comment-text" "css_element"
    And I should see "Comment 5" in the ".studentquiz-comment-item:nth-child(3) .studentquiz-comment-text" "css_element"
    And I should see "Comment 4" in the ".studentquiz-comment-item:nth-child(4) .studentquiz-comment-text" "css_element"
    And I should see "Comment 3" in the ".studentquiz-comment-item:nth-child(5) .studentquiz-comment-text" "css_element"
    # Sort Date ASC.
    And I click on "Date" "link" in the ".studentquiz-comment-filters" "css_element"
    And I wait until the page is ready
    And I should see "Comment 2" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    And I should see "Comment 3" in the ".studentquiz-comment-item:nth-child(2) .studentquiz-comment-text" "css_element"
    And I should see "Comment 4" in the ".studentquiz-comment-item:nth-child(3) .studentquiz-comment-text" "css_element"
    And I should see "Comment 5" in the ".studentquiz-comment-item:nth-child(4) .studentquiz-comment-text" "css_element"
    And I should see "Comment 6" in the ".studentquiz-comment-item:nth-child(5) .studentquiz-comment-text" "css_element"
    # Sort first name ASC.
    And I click on "Forename" "link" in the ".studentquiz-comment-filters" "css_element"
    And I wait until the page is ready
    And I should see "Comment 2" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    And I should see "Comment 5" in the ".studentquiz-comment-item:nth-child(2) .studentquiz-comment-text" "css_element"
    And I should see "Comment 3" in the ".studentquiz-comment-item:nth-child(3) .studentquiz-comment-text" "css_element"
    And I should see "Comment 4" in the ".studentquiz-comment-item:nth-child(4) .studentquiz-comment-text" "css_element"
    And I should see "Comment 7" in the ".studentquiz-comment-item:nth-child(5) .studentquiz-comment-text" "css_element"
    # Sort first name DESC.
    And I click on "Forename" "link" in the ".studentquiz-comment-filters" "css_element"
    # Prevent behat fails (even single run is fine).
    And I wait until the page is ready
    And I should see "Comment 7" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    And I should see "Comment 6" in the ".studentquiz-comment-item:nth-child(2) .studentquiz-comment-text" "css_element"
    And I should see "Comment 4" in the ".studentquiz-comment-item:nth-child(3) .studentquiz-comment-text" "css_element"
    And I should see "Comment 3" in the ".studentquiz-comment-item:nth-child(4) .studentquiz-comment-text" "css_element"
    And I should see "Comment 5" in the ".studentquiz-comment-item:nth-child(5) .studentquiz-comment-text" "css_element"
    # Sort last name ASC.
    And I click on "Surname" "link" in the ".studentquiz-comment-filters" "css_element"
    # Prevent behat fails (even single run is fine).
    And I wait until the page is ready
    And I should see "Comment 5" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    And I should see "Comment 3" in the ".studentquiz-comment-item:nth-child(2) .studentquiz-comment-text" "css_element"
    And I should see "Comment 4" in the ".studentquiz-comment-item:nth-child(3) .studentquiz-comment-text" "css_element"
    And I should see "Comment 2" in the ".studentquiz-comment-item:nth-child(4) .studentquiz-comment-text" "css_element"
    And I should see "Comment 7" in the ".studentquiz-comment-item:nth-child(5) .studentquiz-comment-text" "css_element"
    # Sort last name DESC.
    And I click on "Surname" "link" in the ".studentquiz-comment-filters" "css_element"
    # Prevent behat fails (even single run is fine).
    And I wait until the page is ready
    And I should see "Comment 7" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    And I should see "Comment 6" in the ".studentquiz-comment-item:nth-child(2) .studentquiz-comment-text" "css_element"
    And I should see "Comment 2" in the ".studentquiz-comment-item:nth-child(3) .studentquiz-comment-text" "css_element"
    And I should see "Comment 4" in the ".studentquiz-comment-item:nth-child(4) .studentquiz-comment-text" "css_element"
    And I should see "Comment 3" in the ".studentquiz-comment-item:nth-child(5) .studentquiz-comment-text" "css_element"
    And I log out
    # Check as student 1.
    And I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "student1"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I should see "Date" in the ".studentquiz-comment-filters" "css_element"
    And I should see "Forename" in the ".studentquiz-comment-filters" "css_element"
    And I should see "Surname" in the ".studentquiz-comment-filters" "css_element"
    # Should only see date filter.
    And I am on the "StudentQuiz 2" "mod_studentquiz > View" page
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    And I wait until the page is ready
    And I enter the text "Comment test user 1" into the "Add comment" editor
    And I press "Add comment"
    And I wait until the page is ready
    And I should see "Date" in the ".studentquiz-comment-filters" "css_element"
    And I should not see "Forename" in the ".studentquiz-comment-filters" "css_element"
    And I should not see "Surname" in the ".studentquiz-comment-filters" "css_element"

  @javascript
  Scenario: Test placeholder display after click Add comment.
    When I am on the "StudentQuiz 1" "mod_studentquiz > View" page logged in as "admin"
    And I click on "Start Quiz" "button"
    And I set the field "True" to "1"
    And I press "Check"
    # Wait for comment area init.
    And I wait until the page is ready
    # Check if placeholder has correct text.
    And the "data-placeholder" attribute of ".editor_atto_content_wrap" "css_element" should contain "Enter your comment here ..."
    # Enter "Comment 1".
    And I enter the text "Comment 1" into the "Add comment" editor
    # Check data-placeholder now is empty.
    Then ".editor_atto_content_wrap[data-placeholder='']" "css_element" should exist
    And I press "Add comment"
    And I wait until the page is ready
    And I wait until ".studentquiz-comment-item:nth-child(1)" "css_element" exists
    And I should see "Comment 1" in the ".studentquiz-comment-item:nth-child(1) .studentquiz-comment-text" "css_element"
    # Check placeholder is back with correct text.
    And the "data-placeholder" attribute of ".editor_atto_content_wrap" "css_element" should contain "Enter your comment here ..."
