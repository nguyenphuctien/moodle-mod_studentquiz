<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Hide question in SQ
 *
 * Require POST params:
 * "questionid" is necessary for every request,
 * "courseid" is necessary for every request,
 * "sesskey" is necessary for every request
 * "text" is necessary if the save type is "comment"
 *
 * @package    mod_studentquiz
 * @copyright  2017 HSR (http://www.hsr.ch)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require_once(__DIR__ . '/../../config.php');
require_once(__DIR__ . '/locallib.php');

// Get parameters.
$questionid = required_param('questionid', PARAM_INT);
$courseid = required_param('courseid', PARAM_INT);

// Load course and course module requested.
if ($cmid) {
    if (!$module = get_coursemodule_from_id('studentquiz', $cmid)) {
        throw new moodle_exception("invalidcoursemodule");
    }
    if (!$course = $DB->get_record('course', array('id' => $module->course))) {
        throw new moodle_exception("coursemisconf");
    }
} else {
    throw new moodle_exception("invalidcoursemodule");
}

// Authentication check.
require_login($module->course, false, $module);
require_sesskey();

$data = new \stdClass();
$data->userid = $USER->id;
$data->questionid = $questionid;

question_require_capability_on($questionid, 'edit');

$DB->set_field('studentquiz_question', 'hidden', 1, ['questionid' => $hide]);

\mod_studentquiz\utils::question_save_action($hide, null, studentquiz_helper::STATE_HIDE);
mod_studentquiz_state_notify($questionid, $this->course, $this->cm, 'hidden');
// Purge these questions from the cache.
\question_bank::notify_question_edited($hide);
redirect($this->baseurl);
