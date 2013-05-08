public class customListView {

    public customListView(ApexPages.StandardSetController controller) {
        cec = [select id,name,Case__c,Case__r.CaseNumber,Owner__c,Minutes__c,Case_Subject__c,Case_Date__c,Case_Account__c,Billable__c from Case_Effort__c limit 7];
        showOrHideFlag=true;
    }


    public List<Case_Effort__c> cec{set;get;}
    //public List<Case_Effort__c> cec1{set;get;}
    public List<MyItem> accountList { get; set; }
    public decimal sumHours{set;get;}
    public string selectedval{set;get;}
    public boolean showOrHideFlag{set;get;}
    
    public customListView(ApexPages.StandardController controller) {
        //fetchCustomListRec(1);     
        cec = [select id,name,Case__c,Case__r.CaseNumber,Owner__c,Minutes__c,Case_Subject__c,Case_Date__c,Case_Account__c,Billable__c from Case_Effort__c limit 7];
        showOrHideFlag=true;       
    }
   
    public void fetchCustomListRec(Integer checkLoop){ 
         
        sumHours = 0;
        accountList = new List<MyItem>();
        List<Case_Effort__c>  beforeForLoop;
        if(checkLoop == 1){
            beforeForLoop = [select id,name,Case__c,Case__r.CaseNumber,Owner__c,Minutes__c,Case_Subject__c,Case_Date__c,Case_Account__c,Billable__c from Case_Effort__c ];
        }else if(checkLoop == 2){
            beforeForLoop = [select id,name,Case__c,Case__r.CaseNumber,Owner__c,Minutes__c,Case_Subject__c,Case_Date__c,Case_Account__c,Billable__c from Case_Effort__c where CreatedDate > LAST_WEEK ];    
        }else{
            beforeForLoop = [select id,name,Case__c,Case__r.CaseNumber,Owner__c,Minutes__c,Case_Subject__c,Case_Date__c,Case_Account__c,Billable__c from Case_Effort__c where CreatedDate = TODAY];    
        }
        List<id> rrIds = new List<id>();
        for (Case_Effort__c cecList : beforeForLoop){
            rrIds.add(cecList.owner__c);
        }
        
        List<User> u = [select id,name from user Where Id in :rrIds ];
        Map<id, User> rrsMap = new Map<id, User>();
        for(User a : u){
            rrsMap.put(a.Id,a);
        } 
        
        for (Case_Effort__c ce : beforeForLoop) {
            if(ce.Minutes__c == null){
                sumHours+= 0;    
            }else{
                sumHours+= ce.Minutes__c; 
            }
            
            User thisRr = rrsMap.get(ce.Owner__c);  
            //User u = [select id,name from user where id=:ce.owner__c]; 
            if(thisRr != null){
                accountList.add(new MyItem(ce,thisRr.name));
            }else{}
            
        }   
      
    }
    
    public pagereference showListvalue(){
        showOrHideFlag=false;
        if(selectedval=='All'){
            fetchCustomListRec(1);
        }else if(selectedval=='This Week'){
            fetchCustomListRec(2);
        }else if(selectedval=='Today'){
            fetchCustomListRec(3);
        }else{}
        return null;
    }
    
    
    public pagereference save(){
        for (MyItem i : accountList) {                           
            Case_Effort__c cUpdate = new Case_Effort__c(id=i.a.id);
                //il.name  = i.a.name;              
                cUpdate.Billable__c = i.a.Billable__c ;
                cUpdate.Minutes__c= i.a.Minutes__c;
                cUpdate.Owner__c = i.a.Owner__c;
                
                
                update cUpdate;                
            }
        
        
         return new pagereference('/a03/o');
    
    }
    
    public class MyItem {
        public boolean selected { get; set; }
        public decimal quant { get; set; }
        public Case_Effort__c a { get; set; }
        public String un {set;get;}
        public MyItem(Case_Effort__c chld,String uname) {
            un = uname;
            a = chld;
            
                       
        }
    }

}