package com.student;

import org.mindrot.jbcrypt.BCrypt;

public class Main {
    public static void main(String[] args) {
        String plainPassword = "567";
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        System.out.println("Hashed: " + hashedPassword);
    }
}

