import 'package:flutter/material.dart';

class ComplaintFilterModel {
  String searchQuery;
  String selectedStatus;
  String selectedCategory;
  String sortBy;

  DateTimeRange? selectedDateRange;

  ComplaintFilterModel({
    this.searchQuery = "",
    this.selectedStatus = "All",
    this.selectedCategory = "All",
    this.sortBy = "Newest",
    this.selectedDateRange,
  });

  static const List<String> statuses = [
    "All",
    "Pending",
    "In Progress",
    "Resolved",
    "Rejected",
  ];

  static const List<String> categories = [
    "All",
    "Road",
    "Water",
    "Electricity",
    "Sanitation",
    "Health",
    "Education",
    "Infrastructure",
    "Environment",
    "Public Safety",
    "Other",
  ];

  static const List<String> sortOptions = [
    "Newest",
    "Oldest",
  ];
}