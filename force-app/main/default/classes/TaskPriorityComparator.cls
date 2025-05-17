/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-17-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class TaskPriorityComparator implements System.Comparator<Task> {
    public Integer compare(Task t1, Task t2) {
        if (t1 == null && t2 == null) return 0;
        if (t1 == null) return 1;
        if (t2 == null) return -1;
        String p1 = t1.Priority;
        String p2 = t2.Priority;
        if (p1 == p2) return 0;
        if (p1 == null) return 1;
        if (p2 == null) return -1;
        // High first
        if (p1 == 'High' && p2 != 'High') return -1;
        if (p2 == 'High' && p1 != 'High') return 1;
        // Then Normal
        if (p1 == 'Normal' && p2 != 'Normal') return -1;
        if (p2 == 'Normal' && p1 != 'Normal') return 1;
        // Otherwise (both Low or other), treat as equal
        return 0;
    }
}
