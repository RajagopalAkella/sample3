public class ConvertTemp {
	public static final integer ConstTemp = 10;
    integer Temp;
    public ConvertTemp(){
        this(ConstTemp);
    	system.debug('@@@@@@@@@@@@@@@@@' + Temp);
    }
    public ConvertTemp(integer x){
        Temp = x;
    }
}