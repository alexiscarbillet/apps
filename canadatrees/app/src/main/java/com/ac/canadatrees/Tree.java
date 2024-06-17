package com.ac.canadatrees;

public class Tree {
    private String name;
    private int imageResourceId;
    private String description;
    private String height;
    private String bark;
    private String leaves;

    public Tree(String name, int imageResourceId, String description, String height, String bark, String leaves) {
        this.name = name;
        this.imageResourceId = imageResourceId;
        this.description = description;
        this.height = height;
        this.bark = bark;
        this.leaves = leaves;
    }

    public String getName() {
        return name;
    }

    public int getImageResourceId() {
        return imageResourceId;
    }

    public String getDescription() {
        return description;
    }

    public String getHeight() {
        return height;
    }

    public String getBark() {
        return bark;
    }

    public String getLeaves() {
        return leaves;
    }
}
