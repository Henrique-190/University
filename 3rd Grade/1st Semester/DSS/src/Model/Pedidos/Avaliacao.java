package Model.Pedidos;

import java.time.LocalDateTime;

public class Avaliacao {
    private int month;
    private int year;
    private String desc;
    private int grade;

    public Avaliacao(){
        this.month = LocalDateTime.now().getMonthValue();
        this.year = LocalDateTime.now().getYear();
        this.desc = "";
    }

    public Avaliacao(String desc){
        this.month = LocalDateTime.now().getMonthValue();
        this.year = LocalDateTime.now().getYear();
        this.desc = desc;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public int getGrade() {
        return grade;
    }

    public void setGrade(int grade) {
        this.grade = grade;
    }

    public void setDate(String date){
        this.month = Integer.parseInt(date.substring(4,6));
        this.year = Integer.parseInt(date.substring(0,4));
    }

    public String getID(){
        String month = (String.valueOf(this.month).length()==1)? "0"+ this.month : String.valueOf(this.month);
        return this.year + Integer.toString(this.month);
    }
}
