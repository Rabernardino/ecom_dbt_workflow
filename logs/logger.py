
import os
import logging
import logging.config

from config import LOGS_DIR

configuracao_global = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'padrao': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s',
            'datefmt': '%Y-%m-%d %H:%M:%S'
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'padrao',
        },
        'arquivo': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGS_DIR,'logs.txt'),  
            'encoding': 'utf-8',
            'formatter': 'padrao',
        },
    },
    'loggers': {
        '': {
            'handlers': ['console', 'arquivo'],
            'level': 'DEBUG',
            'propagate': True
        }
    }
}

logging.config.dictConfig(configuracao_global)