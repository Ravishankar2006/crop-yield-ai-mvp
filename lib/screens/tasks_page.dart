import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _cardController;
  late AnimationController _completionController;
  late AnimationController _floatingController;
  
  late Animation<double> _cardAnimation;
  // Removed unused _completionAnimation field
  late Animation<double> _floatingAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  List<Map<String, dynamic>> taskList = [
    {
      "task": "Irrigate field section A",
      "completed": false,
      "priority": "High",
      "category": "Irrigation",
      "dueDate": "2025-09-25",
      "notes": "Check soil moisture before irrigation",
      "estimatedTime": "2 hours",
    },
    {
      "task": "Inspect for pests in corn field",
      "completed": false,
      "priority": "Medium",
      "category": "Monitoring",
      "dueDate": "2025-09-26",
      "notes": "Focus on corn borer signs",
      "estimatedTime": "1 hour",
    },
    {
      "task": "Apply NPK fertilizer to rice",
      "completed": true,
      "priority": "High",
      "category": "Fertilization",
      "dueDate": "2025-09-24",
      "notes": "Applied 25kg per acre",
      "estimatedTime": "3 hours",
    },
    {
      "task": "Harvest wheat section B",
      "completed": false,
      "priority": "High",
      "category": "Harvesting",
      "dueDate": "2025-09-27",
      "notes": "Weather forecast looks good",
      "estimatedTime": "6 hours",
    },
    {
      "task": "Check soil moisture",
      "completed": false,
      "priority": "Low",
      "category": "Monitoring",
      "dueDate": "2025-09-28",
      "notes": "Use soil moisture meter",
      "estimatedTime": "30 minutes",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _completionController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    
    // Removed unused _completionAnimation initialization
    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.linear),
    );

    _cardController.forward();
    _floatingController.repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardController.dispose();
    _completionController.dispose();
    _floatingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void clearCompleted() {
    setState(() {
      taskList.removeWhere((task) => task["completed"] == true);
    });
    _showSnackBar("Completed tasks cleared!", Colors.green[400]!);
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) => _buildAddTaskDialog(),
    ).then((newTask) {
      if (newTask != null) {
        setState(() {
          taskList.add(newTask);
        });
        _showSnackBar("New task added!", Colors.blue[400]!);
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    List<Map<String, dynamic>> filtered = taskList;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((task) =>
              task["task"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task["category"].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((task) =>
              _selectedFilter == 'Completed' ? task["completed"] : !task["completed"])
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildGlassmorphicAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Colors.blue[900]!.withValues(alpha: 0.1),
              Colors.black,
              Colors.purple[900]!.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating background elements
            ...List.generate(4, (index) => _buildFloatingElement(index)),
            
            // Main content
            Column(
              children: [
                _buildSearchAndFilter(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllTasksTab(),
                      _buildTodayTasksTab(),
                      _buildPriorityTasksTab(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: _buildGlassmorphicFAB(),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar() {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.white, Colors.blue[300]!],
        ).createShader(bounds),
        child: Text(
          'Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 56,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
          ),
        ),
      ),
      actions: [
        _buildCompactActionButton(
          icon: Icons.delete_sweep,
          onPressed: clearCompleted,
          color: Colors.red[400]!,
        ),
        SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.purple[500]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list, size: 18),
                          SizedBox(width: 6),
                          Text('All'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.today, size: 18),
                          SizedBox(width: 6),
                          Text('Today'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag, size: 18),
                          SizedBox(width: 6),
                          Text('Priority'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactActionButton({required IconData icon, required VoidCallback onPressed, required Color color}) {
    return Container(
      margin: EdgeInsets.only(right: 6),
      width: 36,
      height: 36,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: Icon(icon, color: color),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElement(int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        final progress = (_floatingAnimation.value + index * 0.25) % 1.0;
        final size = 15.0 + (index * 5);
        
        return Positioned(
          left: (MediaQuery.of(context).size.width * progress) - size/2,
          top: 80 + (index * 120) + (math.sin(progress * 2 * math.pi) * 30),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  [Colors.blue, Colors.purple, Colors.teal, Colors.pink][index].withValues(alpha: 0.3),
                  [Colors.blue, Colors.purple, Colors.teal, Colors.pink][index].withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: [Colors.blue, Colors.purple, Colors.teal, Colors.pink][index].withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Icon(Icons.search, color: Colors.white60),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('Filter: ', style: TextStyle(color: Colors.white70)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  dropdownColor: Colors.grey[900],
                  underline: Container(),
                  style: TextStyle(color: Colors.white),
                  items: ['All', 'Pending', 'Completed']
                      .map((filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllTasksTab() {
    final filteredTasks = _getFilteredTasks();
    return _buildTasksList(filteredTasks);
  }

  Widget _buildTodayTasksTab() {
    final today = DateTime.now();
    final todayTasks = _getFilteredTasks()
        .where((task) => 
            DateTime.parse(task["dueDate"]).day == today.day &&
            DateTime.parse(task["dueDate"]).month == today.month)
        .toList();
    return _buildTasksList(todayTasks);
  }

  Widget _buildPriorityTasksTab() {
    final priorityTasks = _getFilteredTasks();
    priorityTasks.sort((a, b) {
      final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      return priorityOrder[a['priority']]!.compareTo(priorityOrder[b['priority']]!);
    });
    return _buildTasksList(priorityTasks);
  }

  Widget _buildTasksList(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.grey[400]!.withValues(alpha: 0.2),
                    Colors.grey[600]!.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
            ),
            SizedBox(height: 16),
            Text(
              "No tasks found!",
              style: TextStyle(fontSize: 20, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 100),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _cardAnimation,
          builder: (context, child) {
            final delay = index * 0.1;
            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _cardController,
                curve: Interval(delay, 1.0, curve: Curves.elasticOut),
              ),
            );
            
            return Transform.translate(
              offset: Offset(30 * (1 - animation.value), 0),
              child: Opacity(
                opacity: animation.value,
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: _buildGlassmorphicTaskCard(tasks[index], index),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGlassmorphicTaskCard(Map<String, dynamic> task, int index) {
    bool isDone = task["completed"];
    final priorityColor = _getPriorityColor(task["priority"]);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: isDone ? 0.05 : 0.12),
                Colors.white.withValues(alpha: isDone ? 0.02 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDone ? Colors.green[400]!.withValues(alpha: 0.3) : priorityColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDone ? Colors.green[400]! : priorityColor).withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ExpansionTile(
            leading: _buildAnimatedCheckbox(task, priorityColor),
            title: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? Colors.green[300] : Colors.white,
                fontSize: 16,
                fontWeight: isDone ? FontWeight.w500 : FontWeight.w600,
              ),
              child: Text(task["task"]),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildPriorityChip(task["priority"]),
                    SizedBox(width: 8),
                    _buildCategoryChip(task["category"]),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey[400]),
                    SizedBox(width: 4),
                    Text(
                      'Due: ${_formatDate(task["dueDate"])}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            trailing: isDone
                ? AnimatedScale(
                    scale: isDone ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green[400]?.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.green[400], size: 16),
                    ),
                  )
                : Icon(Icons.expand_more, color: Colors.white60),
            children: [
              _buildExpandedContent(task),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCheckbox(Map<String, dynamic> task, Color color) {
    bool isDone = task["completed"];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          task["completed"] = !isDone;
        });
        
        if (!isDone) {
          _completionController.forward().then((_) {
            _completionController.reset();
          });
          _showSnackBar("Task completed! 🎉", Colors.green[400]!);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isDone ? Colors.green[400] : Colors.transparent,
          border: Border.all(
            color: isDone ? Colors.green[400]! : color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: isDone ? [
            BoxShadow(
              color: Colors.green[400]!.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ] : [],
        ),
        child: isDone
            ? Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color = _getPriorityColor(priority);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 10, color: color),
          SizedBox(width: 4),
          Text(
            priority,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[400]?.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[400]?.withValues(alpha: 0.3) ?? Colors.transparent),
      ),
      child: Text(
        category,
        style: TextStyle(fontSize: 10, color: Colors.blue[300], fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildExpandedContent(Map<String, dynamic> task) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailItem('Estimated Time', task["estimatedTime"], Icons.timer),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDetailItem('Due Date', _formatDate(task["dueDate"]), Icons.calendar_today),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDetailItem('Category', task["category"], Icons.category),
          SizedBox(height: 16),
          Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(task["notes"] ?? 'No notes available', style: TextStyle(color: Colors.white70)),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton('Edit', Icons.edit, Colors.blue[400]!, () => _editTask(task)),
              _buildActionButton('Delete', Icons.delete, Colors.red[400]!, () => _deleteTask(task)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white60),
        SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70)),
        Expanded(child: Text(value, style: TextStyle(color: Colors.white))),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: TextButton.icon(
              icon: Icon(icon, color: color, size: 16),
              label: Text(label, style: TextStyle(color: color)),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicFAB() {
    return SizedBox(
      width: 60,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[400]!.withValues(alpha: 0.8),
                  Colors.purple[500]!.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[400]!.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: _addNewTask,
              child: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTaskDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Add New Task', style: TextStyle(color: Colors.white)),
      content: Text('Add task dialog implementation', style: TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Add', style: TextStyle(color: Colors.blue[400])),
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red[400]!;
      case 'medium':
        return Colors.orange[400]!;
      case 'low':
        return Colors.green[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editTask(Map<String, dynamic> task) {
    _showSnackBar("Edit functionality coming soon!", Colors.blue[400]!);
  }

  void _deleteTask(Map<String, dynamic> task) {
    setState(() {
      taskList.remove(task);
    });
    _showSnackBar("Task deleted successfully!", Colors.red[400]!);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
