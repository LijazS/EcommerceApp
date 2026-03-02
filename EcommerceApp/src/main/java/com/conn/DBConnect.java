package com.conn;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect 
{

	private static Connection conn = null;
	
	public static Connection getConn()
	{
		try {
			
// load drivers for both potential databases
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException ignored) {
			}
			try {
				Class.forName("org.sqlite.JDBC");
			} catch (ClassNotFoundException ignored) {
			}

			// allow configuration via environment variables; fallback to SQLite file
			String dbUrl = System.getenv("DB_URL");
			String dbUser = System.getenv("DB_USER");
			String dbPass = System.getenv("DB_PASS");
			if (dbUrl == null || dbUrl.isEmpty()) {
				// default to a local sqlite database in /data, which can be mounted by Docker
				dbUrl = "jdbc:sqlite:/data/mydatabase.db";
			}

			if (dbUrl.startsWith("jdbc:mysql")) {
				// use credentials if provided
				if (dbUser != null && dbPass != null) {
					conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
				} else {
					conn = DriverManager.getConnection(dbUrl);
				}
			} else {
				conn = DriverManager.getConnection(dbUrl);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		
		return conn;
	}
	
}
