package com.ac.canadiananimals;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class BirdAdapter extends RecyclerView.Adapter<BirdAdapter.BirdViewHolder> {

    public interface OnItemClickListener {
        void onItemClick(Bird bird);
    }

    private final List<Bird> birds;

    private BirdAdapter.OnItemClickListener listener;

    public BirdAdapter(List<Bird> birds, BirdAdapter.OnItemClickListener listener) {
        this.birds = birds;
        this.listener = listener;
    }

    @NonNull
    @Override
    public BirdViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_animal, parent, false);
        return new BirdViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull BirdViewHolder holder, int position) {
        Bird bird = birds.get(position);
        holder.bind(bird, listener);
    }

    @Override
    public int getItemCount() {
        return birds.size();
    }

    static class BirdViewHolder extends RecyclerView.ViewHolder {
        ImageView image;
        TextView name;

        BirdViewHolder(View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.itemImage);
            name = itemView.findViewById(R.id.itemName);
        }

        void bind(final Bird bird, final OnItemClickListener listener) {
            image.setImageResource(bird.getImageResourceId());
            name.setText(bird.getName());

            itemView.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onItemClick(bird);
                }
            });
        }
    }
}
