package com.ac.canadiananimals;

public class Mammal {
    private String name;
    private int imageResourceId;
    private String description;
    private String length;
    private String weight;

    public Mammal(String name, int imageResourceId, String description, String length, String weight) {
        this.name = name;
        this.imageResourceId = imageResourceId;
        this.description = description;
        this.length = length;
        this.weight = weight;
    }

    public String getName() { return name; }
    public int getImageResourceId() { return imageResourceId; }
    public String getDescription() { return description; }
    public String getLength() { return length; }
    public String getWeight() { return weight; }
}
