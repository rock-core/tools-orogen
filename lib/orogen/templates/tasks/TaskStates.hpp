/* Generated from orogen/lib/orogen/templates/tasks/TaskStates.hpp */

#ifndef <%= project.name %>_TASKS_STATES
#define <%= project.name %>_TASKS_STATES

<%
def enter_namespace(namespace)
    @current_namespace ||= []
    target_namespace = namespace.split("::")

    code = []
    while target_namespace[0, @current_namespace.size] != @current_namespace
        code << "}"
        @current_namespace.pop
    end

    code.concat(
        target_namespace[@current_namespace.size..-1]
        .map { |ns| "namespace #{ns} {" }
    )

    @current_namespace = target_namespace
    code.join("\n")
end
%>

namespace <%= project.name %>
{
    <% project.self_tasks.
        find_all(&:extended_state_support?).

        each do |task| %>

    <%= enter_namespace task.namespace %>
    enum <%= task.state_type_name %>
    {
        <% states = task.each_state.to_a
           states.each_with_index do |(state_name, state_type), i| %>
            <%= task.state_global_value_name(state_name, state_type) %><%= ',' if i != states.size - 1 %>
        <% end %>
    };
    <% end %>

    <%= enter_namespace "" %>
}

#endif

