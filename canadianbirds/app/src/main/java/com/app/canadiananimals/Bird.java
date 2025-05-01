package com.app.canadianbirds;

public class Bird {
    private String name;
    private int imageResourceId;
    private String description;
    private String length;
    private String weight;
    private String wingspan;

    public Bird(String name, int imageResourceId, String description, String length, String weight, String wingspan) {
        this.name = name;
        this.imageResourceId = imageResourceId;
        this.description = description;
        this.length = length;
        this.weight = weight;
        this.wingspan = wingspan;
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

    public String getWingspan() {
        return wingspan;
    }

    public String getWeight() {
        return weight;
    }

    public String getLength() {
        return length;
    }
}
