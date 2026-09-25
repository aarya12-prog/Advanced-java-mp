/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;
import java.sql.*;

/**
 *
 * @author Sajiv.v
 */
public class DBConnection {
    public static Connection getConnection(){
        Connection con = null;
        
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hardware_inventory","root", "root");
            
        }catch (Exception e){
            e.printStackTrace();
        }
        
        return con;
    }
    
}

