/*
** FamiTracker - NES/Famicom sound tracker
** Copyright (C) 2005-2014  Jonathan Liss
**
** 0CC-FamiTracker is (C) 2014-2015 HertzDevil
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful, 
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
** Library General Public License for more details.  To obtain a 
** copy of the GNU Library General Public License, write to the Free 
** Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
** Any permitted reproduction of these routines, in whole or in part,
** must bear this legend.
*/

#pragma once

#include <vector>		// // //
#include <optional>
#include "Action.h"
#include "PatternEditorTypes.h"

enum transpose_t {
	TRANSPOSE_DEC_NOTES,
	TRANSPOSE_INC_NOTES,
	TRANSPOSE_DEC_OCTAVES,
	TRANSPOSE_INC_OCTAVES
};

/*
	\brief A structure responsible for recording the cursor and selection state of the pattern
	editor for use by pattern actions.
*/
struct CPatternEditorState		// // // TODO: might be moved to PatternEditor.h
{
	/*!	\brief Constructor of the pattern editor state.
		\details On construction, the object retrieves the current state of the pattern editor
		immediately. Once created, a state object remains constant and can be applied back to the
		pattern editor as many times as desired.
		\param pEditor Pointer to the pattern editor.
		\param Track The track number. */
	CPatternEditorState(const CPatternEditor *pEditor, int Track);

	/*!	\brief Applies the state to a pattern editor.
		\param pEditor Pointer to the pattern editor. */
	void ApplyState(CPatternEditor *pEditor) const;

	/*!	\brief The current track number at the time of the state's creation. */
	int Track;

	/*!	\brief The current cursor position at the time of the state's creation. */
	CCursorPos Cursor;

	/*!	\brief The current selection position at the time of the state's creation. */
	CSelection Selection;

	/*!	\brief Whether a selection is active at the time of the state's creation. */
	bool IsSelecting;

private:
	CSelection OriginalSelection;
};

// Pattern commands
class CPatternAction : public Action
{
public:
	enum ACTIONS
	{
		ACT_EDIT_NOTE,			// Keyboard entry, in ANY COLUMN (including instr/vol/effect)

		ACT_INCREASE,			// Numpad + (instr/vol/effect under caret)
		ACT_DECREASE,			// Numpad - (instr/vol/effect under caret)
		ACT_SCROLL_VALUES,		// Shift+Scroll (caret or selection)

		ACT_TRANSPOSE,			// Ctrl+Scroll (caret or selection) 

		ACT_REPLACE_NOTE,		// Find-replace, in ANY COLUMN

		ACT_INSERT_SEL_ROWS,	// Selection + Numpad Insert
		ACT_INSERT_ROW,			// Numpad Insert
		
		ACT_DELETE_ROW,			// Delete/Backspace
		ACT_EDIT_DELETE,		// Selection + Delete
		ACT_EDIT_DELETE_ROWS,	// Selection + Backspace

		ACT_DRAG_AND_DROP,
		ACT_EDIT_PASTE,			// Many different modes

		ACT_INTERPOLATE,		// Ctrl+G
		ACT_REVERSE,
		ACT_REPLACE_INSTRUMENT,	// Selection instrs = highlighted

		ACT_PATTERN_LENGTH,		// CMainFrame::SetRowCount
		ACT_STRETCH_PATTERN,	// Pattern/etc.
		ACT_EFFECT_COLUMNS,		// Effect column arrows
	};

// protected:
public:
	CPatternAction(int iAction);

public:
	virtual ~CPatternAction();

	virtual bool SaveState(const CMainFrame *pMainFrm);
	virtual void Undo(CMainFrame *pMainFrm) const;
	virtual void Redo(CMainFrame *pMainFrm) const;

	void SaveUndoState(const CMainFrame *pMainFrm);		// // //
	void SaveRedoState(const CMainFrame *pMainFrm);		// // //
	void RestoreUndoState(CMainFrame *pMainFrm) const;		// // //
	void RestoreRedoState(CMainFrame *pMainFrm) const;		// // //

public:
	void SetPaste(CPatternClipData *pClipData);
	void SetPasteMode(paste_mode_t Mode);		// // //
	void SetPastePos(paste_pos_t Pos);		// // //
	void SetDragAndDrop(const CPatternClipData *pClipData, bool bDelete, bool bMix, const CSelection *pDragTarget);

private:
	virtual void UpdateView(CFamiTrackerDoc *pDoc) const;		// // //

protected:
	std::optional<CSelection> SetTargetSelection(CPatternEditor * pPatternEditor);
	void DeleteSelection(CMainFrame *pMainFrm, const CSelection &Sel) const;		// // //
	bool ValidateSelection(const CMainFrame *pMainFrm) const;		// // //
	std::pair<CPatternIterator, CPatternIterator> GetIterators(const CMainFrame *pMainFrm) const;		// // //

protected:
	CPatternEditorState *m_pUndoState;		// // //
	CPatternEditorState *m_pRedoState;

private:
	const CPatternClipData *m_pClipData;
	CPatternClipData *m_pUndoClipData, *m_pAuxiliaryClipData;		// // //
	paste_mode_t m_iPasteMode;		// // //
	paste_pos_t m_iPastePos;		// // //
	
	bool m_bSelecting;
	CSelection m_selection, m_newSelection;		// // //

	bool m_bDragDelete;
	bool m_bDragMix;
	CSelection m_dragTarget;
};

/*!
	\brief Specialization of the pattern action class for actions operating on a selection without
	modifying its span.
*/
class CPSelectionAction : public CPatternAction
{
protected:
	CPSelectionAction(int iAction);
	virtual ~CPSelectionAction();
protected:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
protected:
	CPatternClipData *m_pUndoClipData;
};

// // // built-in pattern action subtypes

class CPActionEditNote : public CPatternAction
{
public:
	CPActionEditNote(const stChanNote &Note);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	stChanNote m_NewNote, m_OldNote;
};

class CPActionReplaceNote : public CPatternAction
{
public:
	CPActionReplaceNote(const stChanNote &Note, int Frame, int Row, int Channel);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	stChanNote m_NewNote, m_OldNote;
	int m_iFrame, m_iRow, m_iChannel;
};

class CPActionInsertRow : public CPatternAction
{
public:
	CPActionInsertRow();
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	stChanNote m_OldNote;
};

class CPActionDeleteRow : public CPatternAction
{
public:
	CPActionDeleteRow(bool PullUp, bool Backspace);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	stChanNote m_OldNote;
	bool m_bPullUp, m_bBack;
};

class CPActionScrollField : public CPatternAction		// // //
{
public:
	CPActionScrollField(int Amount);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	stChanNote m_OldNote;
	int m_iAmount;
};

class CPActionClearSel : public CPSelectionAction
{
public:
	CPActionClearSel();
private:
	void Redo(CMainFrame *pMainFrm) const;
};

class CPActionDeleteAtSel : public CPatternAction
{
public:
	CPActionDeleteAtSel();
	virtual ~CPActionDeleteAtSel();
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	CCursorPos m_cpTailPos;
	CPatternClipData *m_pUndoHead, *m_pUndoTail;
};

class CPActionInsertAtSel : public CPatternAction
{
public:
	CPActionInsertAtSel();
	virtual ~CPActionInsertAtSel();
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	CCursorPos m_cpHeadPos, m_cpTailPos;
	CPatternClipData *m_pUndoHead, *m_pUndoTail;
};

class CPActionTranspose : public CPSelectionAction
{
public:
	CPActionTranspose(transpose_t Type);
private:
	void Redo(CMainFrame *pMainFrm) const;
private:
	transpose_t m_iTransposeMode;
};

class CPActionScrollValues : public CPSelectionAction
{
public:
	CPActionScrollValues(int Amount);
private:
	void Redo(CMainFrame *pMainFrm) const;
private:
	int m_iAmount;
};

class CPActionInterpolate : public CPSelectionAction
{
public:
	CPActionInterpolate();
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Redo(CMainFrame *pMainFrm) const;
private:
	int m_iSelectionSize;
};

class CPActionReverse : public CPSelectionAction
{
public:
	CPActionReverse();
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Redo(CMainFrame *pMainFrm) const;
};

class CPActionReplaceInst : public CPSelectionAction
{
public:
	CPActionReplaceInst(unsigned Index);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Redo(CMainFrame *pMainFrm) const;
private:
	unsigned m_iInstrumentIndex;
};

class CPActionDragDrop : public CPatternAction
{
public:
	CPActionDragDrop(const CPatternClipData *pClipData, bool bDelete, bool bMix, const CSelection &pDragTarget);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
private:
	const CPatternClipData *m_pClipData;
	CPatternClipData *m_pUndoClipData, *m_pAuxiliaryClipData;
	bool m_bDragDelete;
	bool m_bDragMix;
	CSelection m_newSelection;
	CSelection m_dragTarget;
};

class CPActionPatternLen : public CPatternAction
{
public:
	CPActionPatternLen(int Length);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
	bool Merge(const Action *Other);		// // //
private:
	int m_iOldPatternLen, m_iNewPatternLen;
};

class CPActionStretch : public CPSelectionAction
{
public:
	CPActionStretch(std::vector<int> Stretch);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Redo(CMainFrame *pMainFrm) const;
private:
	std::vector<int> m_iStretchMap;
};

class CPActionEffColumn : public CPatternAction
{
public:
	CPActionEffColumn(int Channel, int Count);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
	void UpdateView(CFamiTrackerDoc *pDoc) const;
private:
	unsigned m_iChannel;
	unsigned m_iOldColumns, m_iNewColumns;
};

class CPActionHighlight : public CPatternAction		// // //
{
public:
	CPActionHighlight(stHighlight Hl);
private:
	bool SaveState(const CMainFrame *pMainFrm);
	void Undo(CMainFrame *pMainFrm) const;
	void Redo(CMainFrame *pMainFrm) const;
	void UpdateView(CFamiTrackerDoc *pDoc) const;
private:
	stHighlight m_OldHighlight, m_NewHighlight;
};
