package com.app.canadianbirds;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class BirdAdapter extends RecyclerView.Adapter<BirdAdapter.ViewHolder> {

    private List<Bird> birdList;
    private OnItemClickListener listener;

    public BirdAdapter(List<Bird> birdList, OnItemClickListener listener) {
        this.birdList = birdList;
        this.listener = listener;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);

        // Inflate the custom layout
        View itemView = inflater.inflate(R.layout.item_bird, parent, false);

        // Return a new holder instance
        return new ViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Bird bird = birdList.get(position);

        // Set item views based on your views and data model
        holder.birdImageView.setImageResource(bird.getImageResourceId());
        holder.birdNameTextView.setText(bird.getName());
    }

    @Override
    public int getItemCount() {
        return birdList.size();
    }

    public interface OnItemClickListener {
        void onItemClick(Bird bird);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        ImageView birdImageView;
        TextView birdNameTextView;

        public ViewHolder(View itemView) {
            super(itemView);

            birdImageView = itemView.findViewById(R.id.birdImageView);
            birdNameTextView = itemView.findViewById(R.id.birdNameTextView);

            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    int position = getAdapterPosition();
                    if (position != RecyclerView.NO_POSITION) {
                        Bird bird = birdList.get(position);
                        listener.onItemClick(bird);
                    }
                }
            });
        }
    }
}

