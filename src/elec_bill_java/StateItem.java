package elec_bill_java;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Admin
 */
public class StateItem {
    private int stateId;
    private String stateName;
    
    public StateItem(int stateId, String stateName) {
        this.stateId = stateId;
        this.stateName = stateName;
    }
    
    public int getStateId() { return stateId; }
    public String getStateName() { return stateName; }
    
    @Override
    public String toString() { return stateName; }
}
