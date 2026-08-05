import 'package:flutter/material.dart';

class FilterOptionData {
  const FilterOptionData({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final String value;
}

class FilterSectionData {
  const FilterSectionData({
    required this.id,
    required this.title,
    required this.options,
  });

  final String id;
  final String title;
  final List<FilterOptionData> options;
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.sections,
    required this.initialSelection,
    required this.onApply,
  });

  final List<FilterSectionData> sections;
  final Map<String, String?> initialSelection;
  final ValueChanged<Map<String, String?>> onApply;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final Map<String, String?> _selection;

  @override
  void initState() {
    super.initState();
    _selection = Map<String, String?>.from(widget.initialSelection);
  }

  void _resetFilters() {
    setState(() {
      _selection.clear();
    });
  }

  void _applyFilters() {
    widget.onApply(Map<String, String?>.from(_selection));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter & Sort',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Refine your browse results',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final section in widget.sections) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final option in section.options)
                                  ChoiceChip(
                                    label: Text(option.label),
                                    selected:
                                        _selection[section.id] == option.value,
                                    onSelected: (_) {
                                      setState(() {
                                        if (_selection[section.id] ==
                                            option.value) {
                                          _selection.remove(section.id);
                                        } else {
                                          _selection[section.id] = option.value;
                                        }
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    selectedColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    labelStyle: TextStyle(
                                      color:
                                          _selection[section.id] == option.value
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
