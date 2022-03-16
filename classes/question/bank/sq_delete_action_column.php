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

namespace mod_studentquiz\bank;

use core_question\local\bank\menu_action_column_base;
use mod_studentquiz\local\studentquiz_helper;

/**
 * Represent delete action in studentquiz_bank_view.
 *
 * @package mod_studentquiz
 * @copyright 2021 The Open University
 * @license http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class sq_delete_action_column extends menu_action_column_base {

    /**
     * Override method to get url and label for delete action of the studentquiz.
     *
     * @param \stdClass $question The row from the $question table, augmented with extra information.
     * @return array With three elements.
     *      $url - The URL to perform the action.
     *      $icon - The icon for this action.
     *      $label - Text label to display in the UI (either in the menu, or as a tool-tip on the icon).
     */
    protected function get_url_icon_and_label(\stdClass $question): array {

        if ($question->state == studentquiz_helper::STATE_APPROVED &&
                !has_capability('mod/studentquiz:previewothers', $this->qbank->get_most_specific_context())) {
            // Do not render delete icon if the question is in approved state for the student.
            return [null, null, null];
        }

        if (!question_has_capability_on($question, 'edit')) {
            return [null, null, null];
        }
        if ($question->status === question_version_status::QUESTION_STATUS_HIDDEN) {
            $hiddenparams = array(
                'unhide' => $question->id,
                'sesskey' => sesskey());
            $hiddenparams = array_merge($hiddenparams, $this->returnparams);
            $url = new \moodle_url($this->deletequestionurl, $hiddenparams);
            return [$url, 't/restore', $this->strrestore];
        } else {
            $deleteparams = array(
                'deleteselected' => $question->id,
                'q' . $question->id => 1,
                'sesskey' => sesskey());
            $deleteparams = array_merge($deleteparams, $this->returnparams);
            $url = new \moodle_url($this->deletequestionurl, $deleteparams);
            return [$url, 't/delete', $this->strdelete];
        }
    }

    /**
     * @var string $strdelete
     */
    protected $strdelete;

    /**
     * @var string $strrestore
     */
    protected $strrestore;

    /**
     * Contains the url of the delete question page.
     * @var \moodle_url|string
     */
    public $deletequestionurl;

    /**
     * Array of the return parameters.
     * @var array $returnparams
     */
    protected $returnparams;

    public function init(): void {
        parent::init();
        $this->strdelete = get_string('delete');
        $this->strrestore = get_string('restore');
        $this->deletequestionurl = new \moodle_url('/question/bank/deletequestion/delete.php');
        if (!empty($this->qbank->cm->id)) {
            $this->returnparams['cmid'] = $this->qbank->cm->id;
        }
        if (!empty($this->qbank->course->id)) {
            $this->returnparams['courseid'] = $this->qbank->course->id;
        }
        if (!empty($this->qbank->returnurl)) {
            $this->returnparams['returnurl'] = $this->qbank->returnurl;
        }
    }

    public function get_name(): string {
        return 'deleteaction';
    }

    public function get_required_fields(): array {
        $required = parent::get_required_fields();
        return $required;
    }
}
