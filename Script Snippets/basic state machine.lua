SM_states = {current={},last={}}

---Declares the state machine and sets the state machine
function setState(state_machine_name,state_value)
    if SM_states.last[state_machine_name] ~= SM_states.current[state_machine_name] then
        SM_states.last[state_machine_name] = SM_states.current[state_machine_name]
        SM_states.current[state_machine_name] = state_value
    end
end

---Returns the curent and last state in the selected state machine, in a table:  
---`{current,last}`
function getState(state_machine_name)
    return {current=SM_states.current[state_machine_name],last=SM_states.last[state_machine_name]}
end

---Returns true if the state was changed.
function stateChanged(state_machine_name)
    return (SM_states.last[state_machine_name] ~= SM_states.current[state_machine_name])
end