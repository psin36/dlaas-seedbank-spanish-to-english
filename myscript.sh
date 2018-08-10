#!/bin/sh
nvidia-smi --query-gpu=index,name,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l 5  > $LOG_DIR/gpulogs.csv 2>&1 &
pip uninstall -y tensorflow-tensorboard
pip install --upgrade tensorflow-gpu
pip install --upgrade keras
export PYTHONIOENCODING=utf-8
python3 nvidia-smi-nmt_with_attention.py --number_examples=10000