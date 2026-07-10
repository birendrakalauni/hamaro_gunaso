import 'package:flutter/material.dart';
import '../models/complaint_filter_model.dart';

class ComplaintFilters extends StatelessWidget {
  final ComplaintFilterModel filter;

  final VoidCallback onChanged;

  const ComplaintFilters({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search
        TextField(
          decoration: InputDecoration(
            hintText: "Search complaints...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onChanged: (value) {
            filter.searchQuery = value.toLowerCase().trim();
            onChanged();
          },
        ),

        const SizedBox(height: 15),

        // Status + Category
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: filter.selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: ComplaintFilterModel.statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  filter.selectedStatus = value!;
                  onChanged();
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: DropdownButtonFormField<String>(
                value: filter.selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: ComplaintFilterModel.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  filter.selectedCategory = value!;
                  onChanged();
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Sort
        DropdownButtonFormField<String>(
          value: filter.sortBy,
          decoration: const InputDecoration(
            labelText: "Sort",
            border: OutlineInputBorder(),
          ),
          items: ComplaintFilterModel.sortOptions.map((sort) {
            return DropdownMenuItem(value: sort, child: Text(sort));
          }).toList(),
          onChanged: (value) {
            filter.sortBy = value!;
            onChanged();
          },
        ),

        const SizedBox(height: 15),

        // Date Filter
        OutlinedButton.icon(
          icon: const Icon(Icons.date_range),
          label: Text(
            filter.selectedDateRange == null
                ? "Filter by Date"
                : "${filter.selectedDateRange!.start.day}/${filter.selectedDateRange!.start.month}/${filter.selectedDateRange!.start.year}"
                      " - "
                      "${filter.selectedDateRange!.end.day}/${filter.selectedDateRange!.end.month}/${filter.selectedDateRange!.end.year}",
          ),
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );

            if (picked != null) {
              filter.selectedDateRange = picked;
              onChanged();
            }
          },
        ),

        if (filter.selectedDateRange != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text("Clear Date"),
              onPressed: () {
                filter.selectedDateRange = null;
                onChanged();
              },
            ),
          ),
      ],
    );
  }
}
