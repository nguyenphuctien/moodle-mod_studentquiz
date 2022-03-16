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
use qbank_previewquestion\helper;

/**
 * A column type for preview link to mod_studentquiz_preview
 *
 * @package    mod_studentquiz
 * @copyright  2017 HSR (http://www.hsr.ch)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class preview_column extends menu_action_column_base {
    /**
     * @var string store this lang string for performance.
     */
    protected $strpreview;

    /**
     * Renderer
     * @var stdClass
     */
    protected $renderer;

    /** @var stdClass */
    protected $context;

    /** @var string */
    protected $previewtext;

    /**
     * Loads config of current userid and can see
     */
    public function init(): void {
        global $PAGE;
        $this->renderer = $PAGE->get_renderer('mod_studentquiz');
        $this->context = $this->qbank->get_most_specific_context();
        $this->previewtext = get_string('preview');
    }

    /**
     * Look up if current user is allowed to preview this question
     * @param object $question The current question object
     * @return boolean
     */
    private function can_preview($question) {
        global $USER;
        return ($question->createdby == $USER->id) || has_capability('mod/studentquiz:previewothers', $this->context);
    }

    /**
     * Override this function and return the appropriate action menu link, or null if it does not apply to this question.
     *
     * @param \stdClass $question Data about the question being displayed in this row.
     * @return \action_menu_link|null The action, if applicable to this question.
     */
    public function get_action_menu_link(\stdClass $question): ?\action_menu_link {
        if ($this->can_preview($question)) {
            $params = array('cmid' => $this->context->instanceid, 'questionid' => $question->id);
            $link = new \moodle_url('/mod/studentquiz/preview.php', $params);

            return new \action_menu_link_secondary($link, new \pix_icon('t/preview', ''),
                $this->previewtext, ['target' => 'questionpreview']);
        }

        return null;
    }

    public function get_name(): string {
        return 'previewaction';
    }

    protected function get_url_icon_and_label(\stdClass $question): array {
        if (!\question_bank::is_qtype_installed($question->qtype)) {
            // It sometimes happens that people end up with junk questions
            // in their question bank of a type that is no longer installed.
            // We cannot do most actions on them, because that leads to errors.
            return [null, null, null];
        }

        if (question_has_capability_on($question, 'use')) {
            $context = $this->qbank->get_most_specific_context();
            $url = helper::question_preview_url($question->id, null, null,
                null, null, $context, $this->qbank->returnurl);
            return [$url, 't/preview', $this->strpreview];
        } else {
            return [null, null, null];
        }
    }
}
