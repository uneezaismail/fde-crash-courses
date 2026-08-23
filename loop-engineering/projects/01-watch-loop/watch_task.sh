#!/bin/bash
echo "[$(date)] Starting background task..."
# Set to 30 seconds for demonstration - FOR REAL LEARNING EXERCISE, USE 120-240 SECONDS AND WALK AWAY
sleep 30
echo "TASK_DONE" > completion.flag
echo "[$(date)] Background task completed."