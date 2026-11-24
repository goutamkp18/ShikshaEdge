import json
import os

content_pack = {
    "pack_id": "pack_class_6_v1",
    "version": "1.0.0",
    "name": "Class 6 Foundation Learning Pack",
    "class_id": "class_6",
    "class_name": "Class 6",
    "description": "Essential offline lessons and adaptive quizzes for rural school students in Mathematics, Science, and English.",
    "subjects": [
        {
            "id": "math_6",
            "class_id": "class_6",
            "name": "Mathematics",
            "name_kn": "ಗಣಿತ (Mathematics)",
            "icon_name": "calculate",
            "color_hex": "#4F46E5",
            "order_index": 1,
            "topics": [
                {
                    "id": "math_mult",
                    "subject_id": "math_6",
                    "title": "Multiplication",
                    "title_kn": "ಗುಣಾಕಾರ (Multiplication)",
                    "description": "Understand repeated addition, multiplication tables, and word problems.",
                    "description_kn": "ಪುನರಾವರ್ತಿತ ಸಂಕಲನ, ಮಗ್ಗಿಗಳು ಮತ್ತು ವ್ಯವಹಾರಿಕ ಲೆಕ್ಕಗಳನ್ನು ಕಲಿಯಿರಿ.",
                    "order_index": 1,
                    "skills": [
                        {"id": "skill_mult_concept", "name": "Multiplication as Repeated Addition", "name_kn": "ಪುನರಾವರ್ತಿತ ಸಂಕಲನವಾಗಿ ಗುಣಾಕಾರ", "initial_mastery": 0.30},
                        {"id": "skill_mult_tables", "name": "Basic Multiplication Tables", "name_kn": "ಮೂಲ ಮಗ್ಗಿಗಳು", "initial_mastery": 0.30},
                        {"id": "skill_mult_2digit", "name": "Multi-digit Multiplication", "name_kn": "ಎರಡಂಕಿ ಗುಣಾಕಾರ", "initial_mastery": 0.30},
                        {"id": "skill_mult_word", "name": "Multiplication Word Problems", "name_kn": "ಗುಣಾಕಾರದ ವ್ಯವಹಾರಿಕ ಲೆಕ್ಕಗಳು", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [
                        {"skill_id": "skill_mult_tables", "prerequisite_skill_id": "skill_mult_concept"},
                        {"skill_id": "skill_mult_2digit", "prerequisite_skill_id": "skill_mult_tables"},
                        {"skill_id": "skill_mult_word", "prerequisite_skill_id": "skill_mult_2digit"}
                    ],
                    "lessons": [
                        {
                            "id": "lesson_mult_1",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_concept",
                            "title": "What is Multiplication?",
                            "title_kn": "ಗುಣಾಕಾರ ಎಂದರೇನು?",
                            "audio_en_path": "assets/audio/en/mathematics/math_mult_intro.mp3",
                            "audio_kn_path": "assets/audio/kn/mathematics/math_mult_intro.mp3",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Equal Groups",
                                    "title_kn": "ಸಮಾನ ಗುಂಪುಗಳು",
                                    "body": "Multiplication is simply repeated addition! Imagine you have 3 baskets, and each basket contains 4 mangoes. To find the total mangoes, you can add 4 + 4 + 4 = 12. In multiplication, we write this as 3 x 4 = 12.",
                                    "body_kn": "ಗುಣಾಕಾರ ಎಂದರೆ ಪುನರಾವರ್ತಿತ ಸಂಕಲನ! ನಿಮ್ಮ ಬಳಿ 3 ಬುಟ್ಟಿಗಳಿವೆ ಎಂದು ಊಹಿಸಿ, ಪ್ರತಿ ಬುಟ್ಟಿಯಲ್ಲಿ 4 ಮಾವಿನಹಣ್ಣುಗಳಿವೆ. ಒಟ್ಟು ಹಣ್ಣುಗಳನ್ನು ಲೆಕ್ಕ ಮಾಡಲು: 4 + 4 + 4 = 12. ಇದನ್ನು ಗುಣಾಕಾರದಲ್ಲಿ 3 x 4 = 12 ಎಂದು ಬರೆಯುತ್ತೇವೆ.",
                                    "visual_type": "group_diagram",
                                    "visual_data": {"groups": 3, "items_per_group": 4, "item_label": "Mangoes 🥭"}
                                },
                                {
                                    "title": "The Multiplication Symbol (x)",
                                    "title_kn": "ಗುಣಾಕಾರ ಚಿಹ್ನೆ (x)",
                                    "body": "The symbol 'x' tells us how many times a number is repeated. 5 x 2 means '5 times 2' or 2 + 2 + 2 + 2 + 2 = 10.",
                                    "body_kn": "'x' ಚಿಹ್ನೆಯು ಒಂದು ಸಂಖ್ಯೆಯನ್ನು ಎಷ್ಟು ಬಾರಿ ಪುನರಾವರ್ತಿಸಬೇಕು ಎಂದು ತಿಳಿಸುತ್ತದೆ. 5 x 2 ಎಂದರೆ '5 ಬಾರಿ 2' ಅಥವಾ 2 + 2 + 2 + 2 + 2 = 10.",
                                    "visual_type": "number_line",
                                    "visual_data": {"step": 2, "count": 5, "total": 10}
                                },
                                {
                                    "title": "Properties of Multiplication",
                                    "title_kn": "ಗುಣಾಕಾರದ ನಿಯಮಗಳು",
                                    "body": "Order does not matter: 4 x 3 is the exact same as 3 x 4 (both equal 12). Multiplying any number by 0 gives 0. Multiplying any number by 1 gives the same number!",
                                    "body_kn": "ಸಂಖ್ಯೆಗಳ ಸ್ಥಾನ ಬದಲಾದರೂ ಉತ್ತರ ಒಂದೇ: 4 x 3 = 12 ಮತ್ತು 3 x 4 = 12. ಯಾವುದೇ ಸಂಖ್ಯೆಯನ್ನು 0 ಯಿಂದ ಗುಣಿಸಿದರೆ 0 ಬರುತ್ತದೆ. 1 ರಿಂದ ಗುಣಿಸಿದರೆ ಅದೇ ಸಂಖ್ಯೆ ಬರುತ್ತದೆ!",
                                    "visual_type": "rule_card",
                                    "visual_data": {"rule1": "A x B = B x A", "rule2": "N x 0 = 0", "rule3": "N x 1 = N"}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        # 16 questions: 5 Easy, 6 Medium, 5 Hard
                        {
                            "id": "q_mult_01",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_concept",
                            "difficulty": "easy",
                            "question_text": "What is 2 x 3? (Hint: Think 2 groups of 3)",
                            "question_text_kn": "2 x 3 ರ ಮೊತ್ತ ಎಷ್ಟು? (ಸುಳಿವು: 3 ರ 2 ಗುಂಪುಗಳು)",
                            "illustration_type": "dots",
                            "illustration_data": "2x3",
                            "explanation": "2 x 3 means adding 3 two times: 3 + 3 = 6.",
                            "explanation_kn": "2 x 3 ಎಂದರೆ 3 ನ್ನು ಎರಡು ಬಾರಿ ಕೂಡಿಸುವುದು: 3 + 3 = 6.",
                            "hint": "Add 3 + 3.",
                            "hint_kn": "3 + 3 ನ್ನು ಕೂಡಿ ನೋಡಿ.",
                            "audio_en_path": "assets/audio/en/mathematics/math_mult_q1.mp3",
                            "audio_kn_path": "assets/audio/kn/mathematics/math_mult_q1.mp3",
                            "options": [
                                {"id": "opt_01_a", "text": "5", "text_kn": "5", "is_correct": False},
                                {"id": "opt_01_b", "text": "6", "text_kn": "6", "is_correct": True},
                                {"id": "opt_01_c", "text": "7", "text_kn": "7", "is_correct": False},
                                {"id": "opt_01_d", "text": "8", "text_kn": "8", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_02",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_concept",
                            "difficulty": "easy",
                            "question_text": "Express 4 + 4 + 4 as a multiplication sentence.",
                            "question_text_kn": "4 + 4 + 4 ನ್ನು ಗುಣಾಕಾರ ರೂಪದಲ್ಲಿ ಬರೆಯಿರಿ.",
                            "illustration_type": "blocks",
                            "illustration_data": "4+4+4",
                            "explanation": "The number 4 is added 3 times, which is written as 3 x 4.",
                            "explanation_kn": "4 ಸಂಖ್ಯೆಯನ್ನು 3 ಬಾರಿ ಕೂಡಿಸಲಾಗಿದೆ, ಆದ್ದರಿಂದ ಇದನ್ನು 3 x 4 ಎಂದು ಬರೆಯಲಾಗುತ್ತದೆ.",
                            "hint": "Count how many times 4 appears.",
                            "hint_kn": "4 ಸಂಖ್ಯೆ ಎಷ್ಟು ಬಾರಿ ಬಂದಿದೆ ಎಣಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_02_a", "text": "4 x 4", "text_kn": "4 x 4", "is_correct": False},
                                {"id": "opt_02_b", "text": "3 x 4", "text_kn": "3 x 4", "is_correct": True},
                                {"id": "opt_02_c", "text": "4 + 3", "text_kn": "4 + 3", "is_correct": False},
                                {"id": "opt_02_d", "text": "3 + 3 + 3 + 3", "text_kn": "3 + 3 + 3 + 3", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_03",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_tables",
                            "difficulty": "easy",
                            "question_text": "What is 5 x 4?",
                            "question_text_kn": "5 x 4 ರ ಗುಣಲಬ್ಧ ಎಷ್ಟು?",
                            "illustration_type": "stars",
                            "illustration_data": "5x4",
                            "explanation": "5 x 4 = 20. Adding five four times (5+5+5+5) gives 20.",
                            "explanation_kn": "5 x 4 = 20. ಐದನ್ನು ನಾಲ್ಕು ಬಾರಿ ಕೂಡಿಸಿದರೆ 20 ಬರುತ್ತದೆ.",
                            "hint": "Count by fives: 5, 10, 15, ...",
                            "hint_kn": "ಐದೈದಾಗಿ ಎಣಿಸಿ: 5, 10, 15, ...",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_03_a", "text": "15", "text_kn": "15", "is_correct": False},
                                {"id": "opt_03_b", "text": "20", "text_kn": "20", "is_correct": True},
                                {"id": "opt_03_c", "text": "25", "text_kn": "25", "is_correct": False},
                                {"id": "opt_03_d", "text": "24", "text_kn": "24", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_04",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_tables",
                            "difficulty": "easy",
                            "question_text": "What is any number multiplied by 0? (For example, 9 x 0)",
                            "question_text_kn": "ಯಾವುದೇ ಸಂಖ್ಯೆಯನ್ನು 0 ಯಿಂದ ಗುಣಿಸಿದಾಗ ಬರುವ ಉತ್ತರ ಎಷ್ಟು? (ಉದಾ: 9 x 0)",
                            "illustration_type": "zero_rule",
                            "illustration_data": "0",
                            "explanation": "Any number multiplied by zero is always zero.",
                            "explanation_kn": "ಯಾವುದೇ ಸಂಖ್ಯೆಯನ್ನು ಸೊನ್ನೆಯಿಂದ ಗುಣಿಸಿದಾಗ ಬರುವ ಗುಣಲಬ್ಧ ಯಾವಾಗಲೂ ಸೊನ್ನೆ.",
                            "hint": "Zero groups of anything means nothing.",
                            "hint_kn": "ಸೊನ್ನೆ ಗುಂಪುಗಳು ಎಂದರೆ ಏನೂ ಇಲ್ಲ ಎಂದರ್ಥ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_04_a", "text": "0", "text_kn": "0", "is_correct": True},
                                {"id": "opt_04_b", "text": "1", "text_kn": "1", "is_correct": False},
                                {"id": "opt_04_c", "text": "9", "text_kn": "9", "is_correct": False},
                                {"id": "opt_04_d", "text": "10", "text_kn": "10", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_05",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_tables",
                            "difficulty": "easy",
                            "question_text": "What is 10 x 6?",
                            "question_text_kn": "10 x 6 ರ ಬೆಲೆ ಎಷ್ಟು?",
                            "illustration_type": "tens",
                            "illustration_data": "10x6",
                            "explanation": "Multiplying 6 by 10 gives 60. Just attach a 0 to 6.",
                            "explanation_kn": "6 ನ್ನು 10 ರಿಂದ ಗುಣಿಸಿದಾಗ 60 ಬರುತ್ತದೆ. 6 ರ ಪಕ್ಕದಲ್ಲಿ ಸೊನ್ನೆ ಸೇರಿಸಿ.",
                            "hint": "Put a zero next to 6.",
                            "hint_kn": "6 ರ ಮುಂದೆ ಒಂದು ಸೊನ್ನೆ ಇಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_05_a", "text": "16", "text_kn": "16", "is_correct": False},
                                {"id": "opt_05_b", "text": "60", "text_kn": "60", "is_correct": True},
                                {"id": "opt_05_c", "text": "66", "text_kn": "66", "is_correct": False},
                                {"id": "opt_05_d", "text": "106", "text_kn": "106", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_06",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_tables",
                            "difficulty": "medium",
                            "question_text": "What is 7 x 8?",
                            "question_text_kn": "7 x 8 ರ ಗುಣಲಬ್ಧ ಎಷ್ಟು?",
                            "illustration_type": "grid",
                            "illustration_data": "7x8",
                            "explanation": "7 x 8 = 56. (7 x 7 = 49, plus 7 is 56).",
                            "explanation_kn": "7 x 8 = 56. (7 x 7 = 49, ಅದಕ್ಕೆ 7 ಕೂಡಿಸಿದರೆ 56).",
                            "hint": "7 x 7 is 49. Now add 7 more.",
                            "hint_kn": "7 x 7 = 49. ಅದಕ್ಕೆ ಇನ್ನೂ 7 ನ್ನು ಸೇರಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_06_a", "text": "54", "text_kn": "54", "is_correct": False},
                                {"id": "opt_06_b", "text": "56", "text_kn": "56", "is_correct": True},
                                {"id": "opt_06_c", "text": "58", "text_kn": "58", "is_correct": False},
                                {"id": "opt_06_d", "text": "64", "text_kn": "64", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_07",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_tables",
                            "difficulty": "medium",
                            "question_text": "What is 9 x 6?",
                            "question_text_kn": "9 x 6 ರ ಬೆಲೆ ಎಷ್ಟು?",
                            "illustration_type": "grid",
                            "illustration_data": "9x6",
                            "explanation": "9 x 6 = 54. Note that digits 5 + 4 = 9.",
                            "explanation_kn": "9 x 6 = 54. 9 ರ ಮಗ್ಗಿಯಲ್ಲಿ ಅಂಕಿಗಳ ಮೊತ್ತ 9 ಆಗಿರುತ್ತದೆ (5 + 4 = 9).",
                            "hint": "Use 10 x 6 = 60, then subtract 6.",
                            "hint_kn": "10 x 6 = 60, ಅದರಿಂದ 6 ಕಳೆಯಿರಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_07_a", "text": "45", "text_kn": "45", "is_correct": False},
                                {"id": "opt_07_b", "text": "54", "text_kn": "54", "is_correct": True},
                                {"id": "opt_07_c", "text": "56", "text_kn": "56", "is_correct": False},
                                {"id": "opt_07_d", "text": "63", "text_kn": "63", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_08",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_2digit",
                            "difficulty": "medium",
                            "question_text": "Calculate: 12 x 4.",
                            "question_text_kn": "ಲೆಕ್ಕ ಮಾಡಿ: 12 x 4.",
                            "illustration_type": "split_mult",
                            "illustration_data": "(10x4)+(2x4)",
                            "explanation": "12 x 4 = (10 x 4) + (2 x 4) = 40 + 8 = 48.",
                            "explanation_kn": "12 x 4 = (10 x 4) + (2 x 4) = 40 + 8 = 48.",
                            "hint": "Split 12 into 10 and 2.",
                            "hint_kn": "12 ನ್ನು 10 ಮತ್ತು 2 ಎಂದು ಭಾಗಿಸಿ ಗುಣಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_08_a", "text": "44", "text_kn": "44", "is_correct": False},
                                {"id": "opt_08_b", "text": "48", "text_kn": "48", "is_correct": True},
                                {"id": "opt_08_c", "text": "52", "text_kn": "52", "is_correct": False},
                                {"id": "opt_08_d", "text": "50", "text_kn": "50", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_09",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_2digit",
                            "difficulty": "medium",
                            "question_text": "What is 15 x 3?",
                            "question_text_kn": "15 x 3 ರ ಗುಣಲಬ್ಧ ಎಷ್ಟು?",
                            "illustration_type": "clock",
                            "illustration_data": "15x3",
                            "explanation": "15 x 3 = 45. (10 x 3 = 30, and 5 x 3 = 15; 30 + 15 = 45).",
                            "explanation_kn": "15 x 3 = 45. (10 x 3 = 30, ಮತ್ತು 5 x 3 = 15; 30 + 15 = 45).",
                            "hint": "15 + 15 + 15.",
                            "hint_kn": "15 ನ್ನು 3 ಬಾರಿ ಕೂಡಿ: 15 + 15 + 15.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_09_a", "text": "35", "text_kn": "35", "is_correct": False},
                                {"id": "opt_09_b", "text": "40", "text_kn": "40", "is_correct": False},
                                {"id": "opt_09_c", "text": "45", "text_kn": "45", "is_correct": True},
                                {"id": "opt_09_d", "text": "50", "text_kn": "50", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_10",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_word",
                            "difficulty": "medium",
                            "question_text": "A classroom has 6 benches. Each bench seats 4 students. How many students can sit in total?",
                            "question_text_kn": "ಒಂದು ತರಗತಿಯಲ್ಲಿ 6 ಬೆಂಚುಗಳಿವೆ. ಪ್ರತಿ ಬೆಂಚಿನಲ್ಲಿ 4 ವಿದ್ಯಾರ್ಥಿಗಳು ಕುಳಿತುಕೊಳ್ಳಬಹುದು. ಒಟ್ಟು ಎಷ್ಟು ವಿದ್ಯಾರ್ಥಿಗಳು ಕುಳಿತುಕೊಳ್ಳಬಹುದು?",
                            "illustration_type": "classroom",
                            "illustration_data": "6x4",
                            "explanation": "Total students = 6 benches x 4 students = 24 students.",
                            "explanation_kn": "ಒಟ್ಟು ವಿದ್ಯಾರ್ಥಿಗಳು = 6 ಬೆಂಚುಗಳು x 4 ವಿದ್ಯಾರ್ಥಿಗಳು = 24 ವಿದ್ಯಾರ್ಥಿಗಳು.",
                            "hint": "Multiply number of benches by students per bench.",
                            "hint_kn": "ಬೆಂಚುಗಳ ಸಂಖ್ಯೆಯನ್ನು ಪ್ರತಿ ಬೆಂಚಿನ ವಿದ್ಯಾರ್ಥಿಗಳ ಸಂಖ್ಯೆಯಿಂದ ಗುಣಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_10_a", "text": "20", "text_kn": "20", "is_correct": False},
                                {"id": "opt_10_b", "text": "24", "text_kn": "24", "is_correct": True},
                                {"id": "opt_10_c", "text": "26", "text_kn": "26", "is_correct": False},
                                {"id": "opt_10_d", "text": "28", "text_kn": "28", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_11",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_2digit",
                            "difficulty": "medium",
                            "question_text": "What is 25 x 4?",
                            "question_text_kn": "25 x 4 ರ ಮೊತ್ತ ಎಷ್ಟು?",
                            "illustration_type": "money",
                            "illustration_data": "4x25=100",
                            "explanation": "25 x 4 = 100. (Think of 4 quarters of 25 paise making 1 rupee).",
                            "explanation_kn": "25 x 4 = 100. (25 ಪೈಸೆಯ 4 ನಾಣ್ಯಗಳು 1 ರೂಪಾಯಿ = 100 ಪೈಸೆ ಆಗುತ್ತದೆ).",
                            "hint": "Double 25 is 50; double again.",
                            "hint_kn": "25 ರ ದುಪ್ಪಟ್ಟು 50; ಅದರ ದುಪ್ಪಟ್ಟು ಎಷ್ಟು?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_11_a", "text": "75", "text_kn": "75", "is_correct": False},
                                {"id": "opt_11_b", "text": "90", "text_kn": "90", "is_correct": False},
                                {"id": "opt_11_c", "text": "100", "text_kn": "100", "is_correct": True},
                                {"id": "opt_11_d", "text": "125", "text_kn": "125", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_12",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_2digit",
                            "difficulty": "hard",
                            "question_text": "Calculate: 24 x 15.",
                            "question_text_kn": "ಲೆಕ್ಕ ಮಾಡಿ: 24 x 15.",
                            "illustration_type": "long_mult",
                            "illustration_data": "24x15",
                            "explanation": "24 x 15 = 24 x (10 + 5) = 240 + 120 = 360.",
                            "explanation_kn": "24 x 15 = 24 x (10 + 5) = 240 + 120 = 360.",
                            "hint": "Break into (24 x 10) + (24 x 5).",
                            "hint_kn": "(24 x 10) + (24 x 5) ಎಂದು ಬಿಡಿಸಿ ಲೆಕ್ಕ ಮಾಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_12_a", "text": "340", "text_kn": "340", "is_correct": False},
                                {"id": "opt_12_b", "text": "360", "text_kn": "360", "is_correct": True},
                                {"id": "opt_12_c", "text": "380", "text_kn": "380", "is_correct": False},
                                {"id": "opt_12_d", "text": "400", "text_kn": "400", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_13",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_word",
                            "difficulty": "hard",
                            "question_text": "A farmer harvested 18 bags of ragi. Each bag weighs 35 kilograms. What is the total weight in kg?",
                            "question_text_kn": "ಒಬ್ಬ ರೈತ 18 ಚೀಲ ರಾಗಿಯನ್ನು ಬೆಳೆದಿದ್ದಾನೆ. ಪ್ರತಿ ಚೀಲದ ತೂಕ 35 ಕಿಲೋಗ್ರಾಂ. ಒಟ್ಟು ರಾಗಿಯ ತೂಕ ಎಷ್ಟು ಕಿ.ಗ್ರಾಂ?",
                            "illustration_type": "farm_bags",
                            "illustration_data": "18x35",
                            "explanation": "Total weight = 18 x 35 = 18 x (30 + 5) = 540 + 90 = 630 kg.",
                            "explanation_kn": "ಒಟ್ಟು ತೂಕ = 18 x 35 = 18 x (30 + 5) = 540 + 90 = 630 ಕಿ.ಗ್ರಾಂ.",
                            "hint": "Multiply 18 by 35.",
                            "hint_kn": "18 ನ್ನು 35 ರಿಂದ ಗುಣಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_13_a", "text": "580 kg", "text_kn": "580 ಕಿ.ಗ್ರಾಂ", "is_correct": False},
                                {"id": "opt_13_b", "text": "620 kg", "text_kn": "620 ಕಿ.ಗ್ರಾಂ", "is_correct": False},
                                {"id": "opt_13_c", "text": "630 kg", "text_kn": "630 ಕಿ.ಗ್ರಾಂ", "is_correct": True},
                                {"id": "opt_13_d", "text": "650 kg", "text_kn": "650 ಕಿ.ಗ್ರಾಂ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_14",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_2digit",
                            "difficulty": "hard",
                            "question_text": "Find the product: 45 x 22.",
                            "question_text_kn": "ಗುಣಲಬ್ಧವನ್ನು ಕಂಡುಹಿಡಿಯಿರಿ: 45 x 22.",
                            "illustration_type": "long_mult",
                            "illustration_data": "45x22",
                            "explanation": "45 x 22 = 45 x 20 + 45 x 2 = 900 + 90 = 990.",
                            "explanation_kn": "45 x 22 = 45 x 20 + 45 x 2 = 900 + 90 = 990.",
                            "hint": "45 x 2 is 90. 45 x 20 is 900.",
                            "hint_kn": "45 x 2 = 90. 45 x 20 = 900. ಎರಡನ್ನೂ ಕೂಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_14_a", "text": "980", "text_kn": "980", "is_correct": False},
                                {"id": "opt_14_b", "text": "990", "text_kn": "990", "is_correct": True},
                                {"id": "opt_14_c", "text": "1000", "text_kn": "1000", "is_correct": False},
                                {"id": "opt_14_d", "text": "1010", "text_kn": "1010", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_15",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_word",
                            "difficulty": "hard",
                            "question_text": "A school library bought 14 sets of encyclopedias. If each set has 25 books, how many books were bought?",
                            "question_text_kn": "ಶಾಲಾ ಗ್ರಂಥಾಲಯವು 14 ಸೆಟ್ ವಿಶ್ವಕೋಶ ಪುಸ್ತಕಗಳನ್ನು ಖರೀದಿಸಿತು. ಪ್ರತಿ ಸೆಟ್‌ನಲ್ಲಿ 25 ಪುಸ್ತಕಗಳಿದ್ದರೆ, ಒಟ್ಟು ಎಷ್ಟು ಪುಸ್ತಕಗಳನ್ನು ಖರೀದಿಸಲಾಯಿತು?",
                            "illustration_type": "books",
                            "illustration_data": "14x25",
                            "explanation": "14 x 25 = (14 / 4) x 100 or 14 x 25 = 10 x 25 + 4 x 25 = 250 + 100 = 350.",
                            "explanation_kn": "14 x 25 = 10 x 25 + 4 x 25 = 250 + 100 = 350 ಪುಸ್ತಕಗಳು.",
                            "hint": "10 sets = 250 books. Add 4 more sets (100 books).",
                            "hint_kn": "10 ಸೆಟ್‌ಗಳು = 250 ಪುಸ್ತಕಗಳು. ಇನ್ನು 4 ಸೆಟ್‌ಗಳನ್ನು (100 ಪುಸ್ತಕಗಳು) ಸೇರಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_15_a", "text": "320", "text_kn": "320", "is_correct": False},
                                {"id": "opt_15_b", "text": "350", "text_kn": "350", "is_correct": True},
                                {"id": "opt_15_c", "text": "375", "text_kn": "375", "is_correct": False},
                                {"id": "opt_15_d", "text": "400", "text_kn": "400", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_mult_16",
                            "topic_id": "math_mult",
                            "skill_id": "skill_mult_word",
                            "difficulty": "hard",
                            "question_text": "If a train travels 68 km in one hour, how far will it travel in 12 hours at the same speed?",
                            "question_text_kn": "ಒಂದು ರೈಲು ಒಂದು ಗಂಟೆಯಲ್ಲಿ 68 ಕಿ.ಮೀ ಚಲಿಸಿದರೆ, ಅದೇ ವೇಗದಲ್ಲಿ 12 ಗಂಟೆಗಳಲ್ಲಿ ಎಷ್ಟು ದೂರ ಚಲಿಸುತ್ತದೆ?",
                            "illustration_type": "train",
                            "illustration_data": "68x12",
                            "explanation": "Distance = Speed x Time = 68 x 12 = 68 x 10 + 68 x 2 = 680 + 136 = 816 km.",
                            "explanation_kn": "ದೂರ = ವೇಗ x ಕಾಲ = 68 x 12 = 680 + 136 = 816 ಕಿ.ಮೀ.",
                            "hint": "Multiply 68 by 10, then add 68 x 2.",
                            "hint_kn": "68 ನ್ನು 10 ರಿಂದ ಗುಣಿಸಿ, ನಂತರ 68 x 2 ನ್ನು ಕೂಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_16_a", "text": "786 km", "text_kn": "786 ಕಿ.ಮೀ", "is_correct": False},
                                {"id": "opt_16_b", "text": "806 km", "text_kn": "806 ಕಿ.ಮೀ", "is_correct": False},
                                {"id": "opt_16_c", "text": "816 km", "text_kn": "816 ಕಿ.ಮೀ", "is_correct": True},
                                {"id": "opt_16_d", "text": "824 km", "text_kn": "824 ಕಿ.ಮೀ", "is_correct": False}
                            ]
                        }
                    ]
                },
                {
                    "id": "math_div",
                    "subject_id": "math_6",
                    "title": "Division",
                    "title_kn": "ಭಾಗಾಕಾರ (Division)",
                    "description": "Learn equal sharing, quotients, remainders, and simple word problems.",
                    "description_kn": "ಸಮಾನ ಹಂಚಿಕೆ, ಭಾಗಲಬ್ಧ, ಶೇಷ ಮತ್ತು ಸರಳ ಲೆಕ್ಕಗಳನ್ನು ಕಲಿಯಿರಿ.",
                    "order_index": 2,
                    "skills": [
                        {"id": "skill_div_concept", "name": "Division as Equal Sharing", "name_kn": "ಸಮಾನ ಹಂಚಿಕೆಯಾಗಿ ಭಾಗಾಕಾರ", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [],
                    "lessons": [
                        {
                            "id": "lesson_div_1",
                            "topic_id": "math_div",
                            "skill_id": "skill_div_concept",
                            "title": "Introduction to Division",
                            "title_kn": "ಭಾಗಾಕಾರದ ಪರಿಚಯ",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Sharing Equally",
                                    "title_kn": "ಸಮಾನವಾಗಿ ಹಂಚುವುದು",
                                    "body": "Division means splitting a group of things into equal parts. If you have 12 apples and want to share them equally among 3 friends, each friend gets 4 apples. 12 / 3 = 4.",
                                    "body_kn": "ಭಾಗಾಕಾರ ಎಂದರೆ ವಸ್ತುಗಳನ್ನು ಸಮಾನ ಭಾಗಗಳಾಗಿ ಹಂಚುವುದು. ನಿಮ್ಮ ಬಳಿ 12 ಸೇಬುಗಳಿದ್ದು 3 ಜನ ಸ್ನೇಹಿತರಿಗೆ ಸಮನಾಗಿ ಹಂಚಿದರೆ, ಪ್ರತಿಯೊಬ್ಬರಿಗೂ 4 ಸೇಬುಗಳು ಸಿಗುತ್ತವೆ. 12 / 3 = 4.",
                                    "visual_type": "sharing_diagram",
                                    "visual_data": {"total": 12, "parts": 3, "each": 4}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        {
                            "id": "q_div_01",
                            "topic_id": "math_div",
                            "skill_id": "skill_div_concept",
                            "difficulty": "easy",
                            "question_text": "What is 10 / 2?",
                            "question_text_kn": "10 / 2 ರ ಬೆಲೆ ಎಷ್ಟು?",
                            "illustration_type": "division",
                            "illustration_data": "10/2",
                            "explanation": "10 divided equally into 2 parts gives 5 in each part.",
                            "explanation_kn": "10 ನ್ನು 2 ಸಮಭಾಗ ಮಾಡಿದರೆ ಪ್ರತಿ ಭಾಗದಲ್ಲಿ 5 ಇರುತ್ತದೆ.",
                            "hint": "What number times 2 gives 10?",
                            "hint_kn": "ಯಾವ ಸಂಖ್ಯೆಯನ್ನು 2 ರಿಂದ ಗುಣಿಸಿದರೆ 10 ಬರುತ್ತದೆ?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_div_01_a", "text": "4", "text_kn": "4", "is_correct": False},
                                {"id": "opt_div_01_b", "text": "5", "text_kn": "5", "is_correct": True},
                                {"id": "opt_div_01_c", "text": "6", "text_kn": "6", "is_correct": False},
                                {"id": "opt_div_01_d", "text": "8", "text_kn": "8", "is_correct": False}
                            ]
                        }
                    ]
                },
                {
                    "id": "math_frac",
                    "subject_id": "math_6",
                    "title": "Fractions",
                    "title_kn": "ಭಿನ್ನರಾಶಿಗಳು (Fractions)",
                    "description": "Understand parts of a whole, numerators, and denominators.",
                    "description_kn": "ಪೂರ್ಣ ವಸ್ತುವಿನ ಭಾಗಗಳು, ಅಂಶ ಮತ್ತು ಛೇದಗಳನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಿ.",
                    "order_index": 3,
                    "skills": [
                        {"id": "skill_frac_concept", "name": "Understanding Fractions", "name_kn": "ಭಿನ್ನರಾಶಿ ಪರಿಕಲ್ಪನೆ", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [],
                    "lessons": [
                        {
                            "id": "lesson_frac_1",
                            "topic_id": "math_frac",
                            "skill_id": "skill_frac_concept",
                            "title": "What is a Fraction?",
                            "title_kn": "ಭಿನ್ನರಾಶಿ ಎಂದರೇನು?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Parts of a Whole",
                                    "title_kn": "ಪೂರ್ಣ ವಸ್ತುವಿನ ಭಾಗಗಳು",
                                    "body": "A fraction represents a part of a whole. In 1/2, the bottom number (denominator) tells total parts, and the top number (numerator) tells how many parts are taken.",
                                    "body_kn": "ಭಿನ್ನರಾಶಿಯು ಒಂದು ಪೂರ್ಣ ವಸ್ತುವಿನ ಭಾಗವನ್ನು ಸೂಚಿಸುತ್ತದೆ. 1/2 ರಲ್ಲಿ ಕೆಳಗಿನ ಸಂಖ್ಯೆ (ಛೇದ) ಒಟ್ಟು ಭಾಗಗಳನ್ನು ಮತ್ತು ಮೇಲಿನ ಸಂಖ್ಯೆ (ಅಂಶ) ತೆಗೆದುಕೊಂಡ ಭಾಗವನ್ನು ಸೂಚಿಸುತ್ತದೆ.",
                                    "visual_type": "circle_fraction",
                                    "visual_data": {"numerator": 1, "denominator": 2}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        {
                            "id": "q_frac_01",
                            "topic_id": "math_frac",
                            "skill_id": "skill_frac_concept",
                            "difficulty": "easy",
                            "question_text": "In the fraction 3/4, what is the numerator?",
                            "question_text_kn": "3/4 ಭಿನ್ನರಾಶಿಯಲ್ಲಿ 'ಅಂಶ' (numerator) ಯಾವುದು?",
                            "illustration_type": "fraction_box",
                            "illustration_data": "3/4",
                            "explanation": "The top number is the numerator (3), and the bottom number is the denominator (4).",
                            "explanation_kn": "ಮೇಲಿನ ಸಂಖ್ಯೆ ಅಂಶ (3), ಮತ್ತು ಕೆಳಗಿನ ಸಂಖ್ಯೆ ಛೇದ (4).",
                            "hint": "Look at the top number.",
                            "hint_kn": "ಗೆರೆಯ ಮೇಲಿರುವ ಸಂಖ್ಯೆಯನ್ನು ನೋಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_frac_01_a", "text": "3", "text_kn": "3", "is_correct": True},
                                {"id": "opt_frac_01_b", "text": "4", "text_kn": "4", "is_correct": False},
                                {"id": "opt_frac_01_c", "text": "7", "text_kn": "7", "is_correct": False},
                                {"id": "opt_frac_01_d", "text": "1", "text_kn": "1", "is_correct": False}
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "id": "science_6",
            "class_id": "class_6",
            "name": "Science",
            "name_kn": "ವಿಜ್ಞಾನ (Science)",
            "icon_name": "science",
            "color_hex": "#16A34A",
            "order_index": 2,
            "topics": [
                {
                    "id": "sci_photo",
                    "subject_id": "science_6",
                    "title": "Photosynthesis",
                    "title_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆ (Photosynthesis)",
                    "description": "Discover how green plants prepare their own food using sunlight, water, and air.",
                    "description_kn": "ಹಸಿರು ಸಸ್ಯಗಳು ಸೂರ್ಯನ ಬೆಳಕು, ನೀರು ಮತ್ತು ಗಾಳಿಯನ್ನು ಬಳಸಿ ಆಹಾರವನ್ನು ಹೇಗೆ ತಯಾರಿಸುತ್ತವೆ ಎಂದು ತಿಳಿಯಿರಿ.",
                    "order_index": 1,
                    "skills": [
                        {"id": "skill_photo_basics", "name": "Basic Raw Materials", "name_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯ ಮೂಲ ಕಚ್ಚಾ ಸಾಮಗ್ರಿಗಳು", "initial_mastery": 0.30},
                        {"id": "skill_photo_pigments", "name": "Chlorophyll and Stomata", "name_kn": "ಕ್ಲೋರೋಫಿಲ್ ಮತ್ತು ಪತ್ರರಂಧ್ರಗಳು", "initial_mastery": 0.30},
                        {"id": "skill_photo_products", "name": "Products and Energy Conversion", "name_kn": "ಉತ್ಪನ್ನಗಳು ಮತ್ತು ಶಕ್ತಿ ಪರಿವರ್ತನೆ", "initial_mastery": 0.30},
                        {"id": "skill_photo_factors", "name": "Environmental Factors & Experiments", "name_kn": "ಪರಿಸರ ಅಂಶಗಳು ಮತ್ತು ಪ್ರಯೋಗಗಳು", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [
                        {"skill_id": "skill_photo_pigments", "prerequisite_skill_id": "skill_photo_basics"},
                        {"skill_id": "skill_photo_products", "prerequisite_skill_id": "skill_photo_pigments"},
                        {"skill_id": "skill_photo_factors", "prerequisite_skill_id": "skill_photo_products"}
                    ],
                    "lessons": [
                        {
                            "id": "lesson_photo_1",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_basics",
                            "title": "Food Factory of Plants",
                            "title_kn": "ಸಸ್ಯಗಳ ಆಹಾರ ಕಾರ್ಖಾನೆ",
                            "audio_en_path": "assets/audio/en/science/sci_photo_intro.mp3",
                            "audio_kn_path": "assets/audio/kn/science/sci_photo_intro.mp3",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "How Plants Make Food",
                                    "title_kn": "ಸಸ್ಯಗಳು ಆಹಾರ ಹೇಗೆ ತಯಾರಿಸುತ್ತವೆ?",
                                    "body": "Unlike animals, green plants prepare their own food! This process is called Photosynthesis ('photo' = light, 'synthesis' = putting together). Leaves are the food factories of green plants.",
                                    "body_kn": "ಪ್ರಾಣಿಗಳಿಗಿಂತ ಭಿನ್ನವಾಗಿ, ಹಸಿರು ಸಸ್ಯಗಳು ತಮ್ಮ ಆಹಾರವನ್ನು ತಾವೇ ತಯಾರಿಸಿಕೊಳ್ಳುತ್ತವೆ! ಈ ಪ್ರಕ್ರಿಯೆಯನ್ನು ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆ ಎನ್ನುತ್ತಾರೆ ('ದ್ಯುತಿ' = ಬೆಳಕು, 'ಸಂಶ್ಲೇಷಣೆ' = ಒಟ್ಟುಗೂಡಿಸುವುದು). ಎಲೆಗಳು ಸಸ್ಯಗಳ ಆಹಾರ ತಯಾರಿಕಾ ಕಾರ್ಖಾನೆಗಳಾಗಿವೆ.",
                                    "visual_type": "plant_cycle",
                                    "visual_data": {"sunlight": True, "water": True, "co2": True, "oxygen_out": True}
                                },
                                {
                                    "title": "Four Essential Ingredients",
                                    "title_kn": "ನಾಲ್ಕು ಮುಖ್ಯ ಅಗತ್ಯಗಳು",
                                    "body": "Plants need four things: 1. Sunlight (from the sun) 2. Carbon Dioxide (from the air through tiny leaf pores called stomata) 3. Water and minerals (from the soil via roots) 4. Chlorophyll (the green pigment inside leaves that captures sunlight).",
                                    "body_kn": "ಸಸ್ಯಗಳಿಗೆ 4 ಅಗತ್ಯಗಳಿವೆ: 1. ಸೂರ್ಯನ ಬೆಳಕು 2. ಇಂಗಾಲದ ಡೈಆಕ್ಸೈಡ್ (ಪತ್ರರಂಧ್ರಗಳ ಮೂಲಕ ಗಾಳಿಯಿಂದ) 3. ನೀರು ಮತ್ತು ಖನಿಜಗಳು (ಬೇರುಗಳ ಮೂಲಕ ಮಣ್ಣಿನಿಂದ) 4. ಕ್ಲೋರೋಫಿಲ್ ಅಥವಾ ಪತ್ರಹರಿತ್ತು (ಬೆಳಕನ್ನು ಹೀರಿಕೊಳ್ಳುವ ಹಸಿರು ವರ್ಣದ್ರವ್ಯ).",
                                    "visual_type": "leaf_diagram",
                                    "visual_data": {"inputs": ["Sunlight ☀️", "CO2 💨", "Water 💧"], "catalyst": "Chlorophyll 🍃"}
                                },
                                {
                                    "title": "What is Produced?",
                                    "title_kn": "ಏನು ಉತ್ಪತ್ತಿಯಾಗುತ್ತದೆ?",
                                    "body": "Photosynthesis produces Glucose (sugar food for the plant) and releases Oxygen into the air! All living beings need this oxygen to breathe. This is why trees and plants are vital for our planet.",
                                    "body_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯಿಂದ ಗ್ಲುಕೋಸ್ (ಸಸ್ಯಕ್ಕೆ ಆಹಾರವಾದ ಸಕ್ಕರೆ) ಉತ್ಪತ್ತಿಯಾಗುತ್ತದೆ ಮತ್ತು ಆಮ್ಲಜನಕ (Oxygen) ಗಾಳಿಗೆ ಬಿಡುಗಡೆಯಾಗುತ್ತದೆ! ಎಲ್ಲ ಜೀವಿಗಳ ಉಸಿರಾಟಕ್ಕೆ ಈ ಆಮ್ಲಜನಕವೇ ಆಧಾರ.",
                                    "visual_type": "equation_card",
                                    "visual_data": {"left": "CO2 + Water + Light", "right": "Glucose + Oxygen"}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        # 16 questions: 5 Easy, 6 Medium, 5 Hard
                        {
                            "id": "q_photo_01",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_basics",
                            "difficulty": "easy",
                            "question_text": "Which gas do green plants absorb from the atmosphere for photosynthesis?",
                            "question_text_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಗಾಗಿ ಹಸಿರು ಸಸ್ಯಗಳು ವಾತಾವರಣದಿಂದ ಯಾವ ಅನಿಲವನ್ನು ಹೀರಿಕೊಳ್ಳುತ್ತವೆ?",
                            "illustration_type": "leaf_gas",
                            "illustration_data": "co2",
                            "explanation": "Plants take in Carbon Dioxide (CO2) from the air to prepare food.",
                            "explanation_kn": "ಸಸ್ಯಗಳು ಆಹಾರ ತಯಾರಿಸಲು ಗಾಳಿಯಿಂದ ಇಂಗಾಲದ ಡೈಆಕ್ಸೈಡ್ (CO2) ಅನಿಲವನ್ನು ಹೀರಿಕೊಳ್ಳುತ್ತವೆ.",
                            "hint": "It is the gas that animals and humans breathe out.",
                            "hint_kn": "ನಾವು ಉಸಿರು ಹೊರಬಿಡುವಾಗ ಹೊರಬರುವ ಅನಿಲ ಇದು.",
                            "audio_en_path": "assets/audio/en/science/sci_photo_q1.mp3",
                            "audio_kn_path": "assets/audio/kn/science/sci_photo_q1.mp3",
                            "options": [
                                {"id": "opt_p01_a", "text": "Oxygen", "text_kn": "ಆಮ್ಲಜನಕ", "is_correct": False},
                                {"id": "opt_p01_b", "text": "Carbon Dioxide", "text_kn": "ಇಂಗಾಲದ ಡೈಆಕ್ಸೈಡ್", "is_correct": True},
                                {"id": "opt_p01_c", "text": "Nitrogen", "text_kn": "ಸಾರಜನಕ", "is_correct": False},
                                {"id": "opt_p01_d", "text": "Hydrogen", "text_kn": "ಜಲಜನಕ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_02",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_basics",
                            "difficulty": "easy",
                            "question_text": "Which gas is released by green plants during photosynthesis?",
                            "question_text_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯ ಸಮಯದಲ್ಲಿ ಸಸ್ಯಗಳಿಂದ ವಾತಾವರಣಕ್ಕೆ ಬಿಡುಗಡೆಯಾಗುವ ಅನಿಲ ಯಾವುದು?",
                            "illustration_type": "gas_release",
                            "illustration_data": "oxygen",
                            "explanation": "Oxygen is released as a byproduct during photosynthesis, which all animals and humans need for breathing.",
                            "explanation_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯ ಉಪ-ಉತ್ಪನ್ನವಾಗಿ ಆಮ್ಲಜನಕ ಬಿಡುಗಡೆಯಾಗುತ್ತದೆ, ಇದು ಜೀವಿಗಳ ಉಸಿರಾಟಕ್ಕೆ ಅತ್ಯಗತ್ಯ.",
                            "hint": "This is the gas we breathe in to survive.",
                            "hint_kn": "ನಾವು ಜೀವಿಸಲು ಉಸಿರಾಡುವ ಪ್ರಾಣವಾಯು ಇದು.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p02_a", "text": "Carbon Monoxide", "text_kn": "ಕಾರ್ಬನ್ ಮೊನಾಕ್ಸೈಡ್", "is_correct": False},
                                {"id": "opt_p02_b", "text": "Carbon Dioxide", "text_kn": "ಇಂಗಾಲದ ಡೈಆಕ್ಸೈಡ್", "is_correct": False},
                                {"id": "opt_p02_c", "text": "Oxygen", "text_kn": "ಆಮ್ಲಜನಕ", "is_correct": True},
                                {"id": "opt_p02_d", "text": "Helium", "text_kn": "ಹೀಲಿಯಂ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_03",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_pigments",
                            "difficulty": "easy",
                            "question_text": "What is the green pigment in leaves that traps sunlight?",
                            "question_text_kn": "ಸೂರ್ಯನ ಬೆಳಕನ್ನು ಹಿಡಿದಿಡುವ ಎಲೆಗಳಲ್ಲಿರುವ ಹಸಿರು ವರ್ಣದ್ರವ್ಯ ಯಾವುದು?",
                            "illustration_type": "chlorophyll",
                            "illustration_data": "green_leaf",
                            "explanation": "Chlorophyll gives leaves their green color and captures sunlight for photosynthesis.",
                            "explanation_kn": "ಕ್ಲೋರೋಫಿಲ್ (ಪತ್ರಹರಿತ್ತು) ಎಲೆಗಳಿಗೆ ಹಸಿರು ಬಣ್ಣ ನೀಡುತ್ತದೆ ಮತ್ತು ಬೆಳಕನ್ನು ಹಿಡಿದಿಡುತ್ತದೆ.",
                            "hint": "Starts with 'Chloro-'.",
                            "hint_kn": "ಇದನ್ನು ಕನ್ನಡದಲ್ಲಿ ಪತ್ರಹರಿತ್ತು ಎಂದೂ ಕರೆಯುತ್ತಾರೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p03_a", "text": "Hemoglobin", "text_kn": "ಹಿಮೋಗ್ಲೋಬಿನ್", "is_correct": False},
                                {"id": "opt_p03_b", "text": "Chlorophyll", "text_kn": "ಕ್ಲೋರೋಫಿಲ್ (ಪತ್ರಹರಿತ್ತು)", "is_correct": True},
                                {"id": "opt_p03_c", "text": "Melanin", "text_kn": "ಮೆಲನಿನ್", "is_correct": False},
                                {"id": "opt_p03_d", "text": "Carotene", "text_kn": "ಕ್ಯಾರೊಟಿನ್", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_04",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_basics",
                            "difficulty": "easy",
                            "question_text": "What is the primary source of energy for photosynthesis?",
                            "question_text_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಗೆ ಮುಖ್ಯ ಶಕ್ತಿಯ ಮೂಲ ಯಾವುದು?",
                            "illustration_type": "sun",
                            "illustration_data": "sunlight",
                            "explanation": "The Sun provides the solar energy that powers food production in green plants.",
                            "explanation_kn": "ಸೂರ್ಯನು ನೀಡುವ ಸೌರಶಕ್ತಿಯು ಸಸ್ಯಗಳಲ್ಲಿ ಆಹಾರ ತಯಾರಿಕೆಗೆ ಮೂಲ ಚಾಲನಾ ಶಕ್ತಿಯಾಗಿದೆ.",
                            "hint": "Look up at the daytime sky.",
                            "hint_kn": "ಹಗಲಿನಲ್ಲಿ ನಮಗೆ ಬೆಳಕು ಮತ್ತು ಶಾಖ ನೀಡುವ ಆಕಾಶ ಕಾಯ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p04_a", "text": "Wind", "text_kn": "ಗಾಳಿ", "is_correct": False},
                                {"id": "opt_p04_b", "text": "Sunlight", "text_kn": "ಸೂರ್ಯನ ಬೆಳಕು", "is_correct": True},
                                {"id": "opt_p04_c", "text": "Moonlight", "text_kn": "ಚಂದ್ರನ ಬೆಳಕು", "is_correct": False},
                                {"id": "opt_p04_d", "text": "Electricity", "text_kn": "ವಿದ್ಯುತ್", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_05",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_basics",
                            "difficulty": "easy",
                            "question_text": "Which part of the plant absorbs water and minerals from the soil?",
                            "question_text_kn": "ಮಣ್ಣಿನಿಂದ ನೀರು ಮತ್ತು ಖನಿಜಗಳನ್ನು ಹೀರಿಕೊಳ್ಳುವ ಸಸ್ಯದ ಭಾಗ ಯಾವುದು?",
                            "illustration_type": "roots",
                            "illustration_data": "root_system",
                            "explanation": "Roots grow underground to anchor the plant and absorb water and minerals.",
                            "explanation_kn": "ಬೇರುಗಳು ಮಣ್ಣಿನಲ್ಲಿ ಹರಡಿಕೊಂಡು ನೀರು ಮತ್ತು ಪೋಷಕಾಂಶಗಳನ್ನು ಹೀರುತ್ತವೆ.",
                            "hint": "The part underground.",
                            "hint_kn": "ಮಣ್ಣಿನ ಕೆಳಗೆ ಬೆಳೆಯುವ ಭಾಗ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p05_a", "text": "Flowers", "text_kn": "ಹೂಗಳು", "is_correct": False},
                                {"id": "opt_p05_b", "text": "Roots", "text_kn": "ಬೇರುಗಳು", "is_correct": True},
                                {"id": "opt_p05_c", "text": "Stem", "text_kn": "ಕಾಂಡ", "is_correct": False},
                                {"id": "opt_p05_d", "text": "Leaves", "text_kn": "ಎಲೆಗಳು", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_06",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_pigments",
                            "difficulty": "medium",
                            "question_text": "What are the tiny microscopic pores on the surface of leaves called?",
                            "question_text_kn": "ಎಲೆಗಳ ಮೇಲ್ಮೈಯಲ್ಲಿರುವ ಸೂಕ್ಷ್ಮ ರಂಧ್ರಗಳನ್ನು ಏನೆಂದು ಕರೆಯುತ್ತಾರೆ?",
                            "illustration_type": "stomata",
                            "illustration_data": "pore",
                            "explanation": "Stomata are microscopic openings controlled by guard cells that allow gases to enter and leave.",
                            "explanation_kn": "ಪತ್ರರಂಧ್ರಗಳು (Stomata) ಅನಿಲಗಳ ವಿನಿಮಯಕ್ಕೆ ನೆರವಾಗುವ ಎಲೆಯ ಸೂಕ್ಷ್ಮ ದ್ವಾರಗಳಾಗಿವೆ.",
                            "hint": "They allow gas exchange in leaves.",
                            "hint_kn": "ಇವು ಗಾರ್ಡ್ ಕೋಶಗಳಿಂದ ನಿಯಂತ್ರಿಸಲ್ಪಡುವ ರಂಧ್ರಗಳು.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p06_a", "text": "Veins", "text_kn": "ನಾಳಗಳು", "is_correct": False},
                                {"id": "opt_p06_b", "text": "Stomata", "text_kn": "ಪತ್ರರಂಧ್ರಗಳು (Stomata)", "is_correct": True},
                                {"id": "opt_p06_c", "text": "Spines", "text_kn": "ಮುಳ್ಳುಗಳು", "is_correct": False},
                                {"id": "opt_p06_d", "text": "Petals", "text_kn": "ದಳಗಳು", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_07",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_products",
                            "difficulty": "medium",
                            "question_text": "What simple sugar is produced as food during photosynthesis?",
                            "question_text_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯಲ್ಲಿ ಆಹಾರವಾಗಿ ತಯಾರಾಗುವ ಸರಳ ಸಕ್ಕರೆ ಯಾವುದು?",
                            "illustration_type": "glucose",
                            "illustration_data": "c6h12o6",
                            "explanation": "Glucose is the simple sugar formed, which plants use for energy and store as starch.",
                            "explanation_kn": "ಗ್ಲುಕೋಸ್ ಸಸ್ಯಗಳಲ್ಲಿ ತಯಾರಾಗುವ ಸರಳ ಸಕ್ಕರೆಯಾಗಿದ್ದು, ಶಕ್ತಿ ನೀಡುತ್ತದೆ.",
                            "hint": "C6H12O6.",
                            "hint_kn": "ಇದು ಸಸ್ಯದ ಜೀವಕೋಶಗಳಿಗೆ ಶಕ್ತಿ ಕೊಡುವ ಇಂಧನ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p07_a", "text": "Protein", "text_kn": "ಪ್ರೋಟೀನ್", "is_correct": False},
                                {"id": "opt_p07_b", "text": "Glucose", "text_kn": "ಗ್ಲುಕೋಸ್", "is_correct": True},
                                {"id": "opt_p07_c", "text": "Fats", "text_kn": "ಕೊಬ್ಬು", "is_correct": False},
                                {"id": "opt_p07_d", "text": "Salt", "text_kn": "ಉಪ್ಪು", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_08",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_products",
                            "difficulty": "medium",
                            "question_text": "In what form do plants store excess glucose in their tissues?",
                            "question_text_kn": "ಸಸ್ಯಗಳು ಹೆಚ್ಚುವರಿ ಗ್ಲುಕೋಸ್ ಅನ್ನು ಯಾವ ರೂಪದಲ್ಲಿ ಸಂಗ್ರಹಿಸುತ್ತವೆ?",
                            "illustration_type": "starch",
                            "illustration_data": "potato_starch",
                            "explanation": "Plants convert excess glucose into starch and store it in roots, stems, and seeds (like potatoes and grains).",
                            "explanation_kn": "ಹೆಚ್ಚುವರಿ ಗ್ಲುಕೋಸ್ ಅನ್ನು ಸಸ್ಯಗಳು ಪಿಷ್ಟ (Starch) ರೂಪದಲ್ಲಿ ಬೇರು ಮತ್ತು ಕಾಂಡಗಳಲ್ಲಿ ಸಂಗ್ರಹಿಸುತ್ತವೆ.",
                            "hint": "Tested using iodine solution.",
                            "hint_kn": "ಆಲೂಗಡ್ಡೆ ಮತ್ತು ಅಕ್ಕಿಯಲ್ಲಿ ಹೆಚ್ಚಾಗಿರುವ ಪದಾರ್ಥ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p08_a", "text": "Starch", "text_kn": "ಪಿಷ್ಟ (Starch)", "is_correct": True},
                                {"id": "opt_p08_b", "text": "Oil", "text_kn": "ಎಣ್ಣೆ", "is_correct": False},
                                {"id": "opt_p08_c", "text": "Vitamins", "text_kn": "ವಿಟಮಿನ್‌ಗಳು", "is_correct": False},
                                {"id": "opt_p08_d", "text": "Water", "text_kn": "ನೀರು", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_09",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_pigments",
                            "difficulty": "medium",
                            "question_text": "Which specialized plant tissue transports water from roots upward to the leaves?",
                            "question_text_kn": "ಬೇರುಗಳಿಂದ ನೀರನ್ನು ಎಲೆಗಳಿಗೆ ಮೇಲಕ್ಕೆ ಸಾಗಿಸುವ ಸಸ್ಯದ ನಾಳೀಯ ಅಂಗಾಂಶ ಯಾವುದು?",
                            "illustration_type": "xylem_phloem",
                            "illustration_data": "xylem",
                            "explanation": "Xylem vessels conduct water and dissolved minerals from roots to leaves.",
                            "explanation_kn": "ಜೈಲಂ (Xylem / ದಾರು) ಬೇರುಗಳಿಂದ ನೀರನ್ನು ಸಸ್ಯದ ಮೇಲ್ಭಾಗಕ್ಕೆ ಸಾಗಿಸುತ್ತದೆ.",
                            "hint": "Starts with 'X'.",
                            "hint_kn": "ಇದನ್ನು ಕನ್ನಡದಲ್ಲಿ 'ದಾರು' (Xylem) ಎಂದು ಕರೆಯುತ್ತಾರೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p09_a", "text": "Phloem", "text_kn": "ಫ್ಲೋಯಂ (ತಂತು)", "is_correct": False},
                                {"id": "opt_p09_b", "text": "Xylem", "text_kn": "ಜೈಲಂ (ದಾರು)", "is_correct": True},
                                {"id": "opt_p09_c", "text": "Cortex", "text_kn": "ಕಾರ್ಟೆಕ್ಸ್", "is_correct": False},
                                {"id": "opt_p09_d", "text": "Epidermis", "text_kn": "ಎಪಿಡರ್ಮಿಸ್", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_10",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_pigments",
                            "difficulty": "medium",
                            "question_text": "Which plant cells surround and control the opening and closing of stomata?",
                            "question_text_kn": "ಪತ್ರರಂಧ್ರಗಳ ತೆರೆಯುವಿಕೆ ಮತ್ತು ಮುಚ್ಚುವಿಕೆಯನ್ನು ನಿಯಂತ್ರಿಸುವ ಕೋಶಗಳು ಯಾವುವು?",
                            "illustration_type": "guard_cells",
                            "illustration_data": "guard",
                            "explanation": "Guard cells swell and shrink to open and close the stomatal pore.",
                            "explanation_kn": "ರಕ್ಷಕ ಕೋಶಗಳು (Guard cells) ಪತ್ರರಂಧ್ರಗಳು ತೆರೆಯಲು ಮತ್ತು ಮುಚ್ಚಲು ನೆರವಾಗುತ್ತವೆ.",
                            "hint": "They 'guard' the entrance.",
                            "hint_kn": "ರಕ್ಷಣೆ ಮಾಡುವ ಕೋಶಗಳು.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p10_a", "text": "Guard cells", "text_kn": "ರಕ್ಷಕ ಕೋಶಗಳು (Guard cells)", "is_correct": True},
                                {"id": "opt_p10_b", "text": "Nerve cells", "text_kn": "ನರ ಕೋಶಗಳು", "is_correct": False},
                                {"id": "opt_p10_c", "text": "Root hairs", "text_kn": "ಮೂಲರೋಮಗಳು", "is_correct": False},
                                {"id": "opt_p10_d", "text": "Bark cells", "text_kn": "ತೊಗಟೆಯ ಕೋಶಗಳು", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_11",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_products",
                            "difficulty": "medium",
                            "question_text": "Which energy transformation takes place in photosynthesis?",
                            "question_text_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯಲ್ಲಿ ಯಾವ ರೀತಿಯ ಶಕ್ತಿ ರೂಪಾಂತರ ನಡೆಯುತ್ತದೆ?",
                            "illustration_type": "energy_flow",
                            "illustration_data": "light_to_chemical",
                            "explanation": "Light energy from the Sun is transformed into Chemical energy stored in food.",
                            "explanation_kn": "ಸೂರ್ಯನ ಬೆಳಕಿನ ಶಕ್ತಿಯು ಆಹಾರದಲ್ಲಿ ರಾಸಾಯನಿಕ ಶಕ್ತಿಯಾಗಿ ಬದಲಾಗುತ್ತದೆ.",
                            "hint": "From sunlight to food chemicals.",
                            "hint_kn": "ಬೆಳಕಿನ ಶಕ್ತಿಯಿಂದ ರಾಸಾಯನಿಕ ಶಕ್ತಿಗೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p11_a", "text": "Heat energy to Electrical energy", "text_kn": "ಶಾಖ ಶಕ್ತಿಯಿಂದ ವಿದ್ಯುತ್ ಶಕ್ತಿ", "is_correct": False},
                                {"id": "opt_p11_b", "text": "Light energy to Chemical energy", "text_kn": "ಬೆಳಕಿನ ಶಕ್ತಿಯಿಂದ ರಾಸಾಯನಿಕ ಶಕ್ತಿ", "is_correct": True},
                                {"id": "opt_p11_c", "text": "Chemical energy to Sound energy", "text_kn": "ರಾಸಾಯನಿಕ ಶಕ್ತಿಯಿಂದ ಶಬ್ದ ಶಕ್ತಿ", "is_correct": False},
                                {"id": "opt_p11_d", "text": "Kinetic energy to Heat energy", "text_kn": "ಚಲನ ಶಕ್ತಿಯಿಂದ ಶಾಖ ಶಕ್ತಿ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_12",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_factors",
                            "difficulty": "hard",
                            "question_text": "What chemical test confirms the occurrence of photosynthesis in a green leaf?",
                            "question_text_kn": "ಹಸಿರು ಎಲೆಯಲ್ಲಿ ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆ ನಡೆದಿದೆ ಎಂದು ಖಚಿತಪಡಿಸಲು ಯಾವ ರಾಸಾಯನಿಕ ಪರೀಕ್ಷೆಯನ್ನು ಬಳಸಲಾಗುತ್ತದೆ?",
                            "illustration_type": "iodine_test",
                            "illustration_data": "blue_black",
                            "explanation": "The Iodine Test turns starch blue-black, proving glucose and starch were formed.",
                            "explanation_kn": "ಅಯೋಡಿನ್ ದ್ರಾವಣವನ್ನು ಹಾಕಿದಾಗ ಪಿಷ್ಟವು ನೀಲಿ-ಕಪ್ಪು ಬಣ್ಣಕ್ಕೆ ತಿರುಗುತ್ತದೆ.",
                            "hint": "Uses a yellowish-brown solution that turns blue-black.",
                            "hint_kn": "ಅಯೋಡಿನ್ (Iodine) ಪರೀಕ್ಷೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p12_a", "text": "Litmus test", "text_kn": "ಲಿಟ್ಮಸ್ ಪರೀಕ್ಷೆ", "is_correct": False},
                                {"id": "opt_p12_b", "text": "Iodine test for starch", "text_kn": "ಪಿಷ್ಟಕ್ಕಾಗಿ ಅಯೋಡಿನ್ ಪರೀಕ್ಷೆ", "is_correct": True},
                                {"id": "opt_p12_c", "text": "Flame test", "text_kn": "ಜ್ವಾಲೆಯ ಪರೀಕ್ಷೆ", "is_correct": False},
                                {"id": "opt_p12_d", "text": "Salt test", "text_kn": "ಉಪ್ಪಿನ ಪರೀಕ್ಷೆ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_13",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_factors",
                            "difficulty": "hard",
                            "question_text": "How do desert plants (like cactus) adapt their leaves to conserve water?",
                            "question_text_kn": "ನೀರಿನ ನಷ್ಟವನ್ನು ತಡೆಯಲು ಮರುಭೂಮಿ ಸಸ್ಯಗಳು (ಉದಾ: ಪಾಪಾಸುಕಳ್ಳಿ) ತಮ್ಮ ಎಲೆಗಳನ್ನು ಹೇಗೆ ಮಾರ್ಪಡಿಸಿಕೊಂಡಿವೆ?",
                            "illustration_type": "cactus",
                            "illustration_data": "spines",
                            "explanation": "Leaves are modified into sharp spines to minimize water loss by transpiration, while the fleshy green stem performs photosynthesis.",
                            "explanation_kn": "ನೀರು ಆವಿಯಾಗುವುದನ್ನು ತಡೆಯಲು ಎಲೆಗಳು ಮುಳ್ಳುಗಳಾಗಿ ಬದಲಾಗಿವೆ ಮತ್ತು ಹಸಿರು ಕಾಂಡವೇ ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆ ನಡೆಸುತ್ತದೆ.",
                            "hint": "Think of sharp cactus needles.",
                            "hint_kn": "ಚುಚ್ಚುವ ಮುಳ್ಳುಗಳಾಗಿ ಬದಲಾಗಿರುತ್ತವೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p13_a", "text": "Leaves turn into flowers", "text_kn": "ಎಲೆಗಳು ಹೂಗಳಾಗುತ್ತವೆ", "is_correct": False},
                                {"id": "opt_p13_b", "text": "Leaves are reduced to spines", "text_kn": "ಎಲೆಗಳು ಮುಳ್ಳುಗಳಾಗಿ ರೂಪಾಂತರಗೊಂಡಿವೆ", "is_correct": True},
                                {"id": "opt_p13_c", "text": "Leaves become wider", "text_kn": "ಎಲೆಗಳು ಅಗಲವಾಗುತ್ತವೆ", "is_correct": False},
                                {"id": "opt_p13_d", "text": "Leaves produce fruits", "text_kn": "ಎಲೆಗಳು ಹಣ್ಣು ಬಿಡುತ್ತವೆ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_14",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_factors",
                            "difficulty": "hard",
                            "question_text": "Why does photosynthesis stop completely inside a dark cupboard?",
                            "question_text_kn": "ಕತ್ತಲೆಯ ಕಪಾಟಿನಲ್ಲಿಟ್ಟ ಸಸ್ಯದಲ್ಲಿ ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆ ಸಂಪೂರ್ಣವಾಗಿ ಏಕೆ ನಿಲ್ಲುತ್ತದೆ?",
                            "illustration_type": "dark_box",
                            "illustration_data": "no_light",
                            "explanation": "Without sunlight, chlorophyll cannot energize the chemical reaction needed to combine CO2 and water.",
                            "explanation_kn": "ಸೂರ್ಯನ ಬೆಳಕಿಲ್ಲದೆ ಕ್ಲೋರೋಫಿಲ್ ಆಹಾರ ತಯಾರಿಕೆಯ ರಾಸಾಯನಿಕ ಕ್ರಿಯೆಯನ್ನು ನಡೆಸಲು ಸಾಧ್ಯವಿಲ್ಲ.",
                            "hint": "One of the essential energy sources is absent.",
                            "hint_kn": "ಮುಖ್ಯ ಶಕ್ತಿಯಾದ ಬೆಳಕು ಇರುವುದಿಲ್ಲ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p14_a", "text": "Temperature becomes freezing", "text_kn": "ತಾಪಮಾನ ಶೂನ್ಯವಾಗುತ್ತದೆ", "is_correct": False},
                                {"id": "opt_p14_b", "text": "Lack of light energy prevents the reaction", "text_kn": "ಬೆಳಕಿನ ಶಕ್ತಿಯ ಕೊರತೆಯಿಂದ ಕ್ರಿಯೆ ನಡೆಯುವುದಿಲ್ಲ", "is_correct": True},
                                {"id": "opt_p14_c", "text": "Roots stop taking oxygen", "text_kn": "ಬೇರುಗಳು ಆಮ್ಲಜನಕ ಹೀರುವುದು ನಿಲ್ಲುತ್ತದೆ", "is_correct": False},
                                {"id": "opt_p14_d", "text": "Leaves turn yellow instantly", "text_kn": "ಎಲೆಗಳು ತಕ್ಷಣ ಹಳದಿಯಾಗುತ್ತವೆ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_15",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_factors",
                            "difficulty": "hard",
                            "question_text": "What happens to the rate of photosynthesis if carbon dioxide concentration increases moderately under bright sunlight?",
                            "question_text_kn": "ಸಾಕಷ್ಟು ಸೂರ್ಯನ ಬೆಳಕಿನಲ್ಲಿ ಗಾಳಿಯಲ್ಲಿ ಇಂಗಾಲದ ಡೈಆಕ್ಸೈಡ್ ಪ್ರಮಾಣ ಹೆಚ್ಚಾದರೆ ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯ ದರ ಏನಾಗುತ್ತದೆ?",
                            "illustration_type": "rate_graph",
                            "illustration_data": "rate_increase",
                            "explanation": "More CO2 provides more raw carbon atoms, speeding up photosynthesis until another factor becomes limiting.",
                            "explanation_kn": "ಹೆಚ್ಚಿನ ಇಂಗಾಲದ ಡೈಆಕ್ಸೈಡ್ ದೊರೆತಾಗ ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯ ವೇಗ ಹೆಚ್ಚಾಗುತ್ತದೆ.",
                            "hint": "More ingredients allow more food production.",
                            "hint_kn": "ಕಚ್ಚಾ ಸಾಮಗ್ರಿ ಹೆಚ್ಚಿದಂತೆ ಆಹಾರ ತಯಾರಿಕೆ ವೇಗವಾಗುತ್ತದೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p15_a", "text": "It decreases rapidly", "text_kn": "ವೇಗವಾಗಿ ಕಡಿಮೆಯಾಗುತ್ತದೆ", "is_correct": False},
                                {"id": "opt_p15_b", "text": "It increases", "text_kn": "ಹೆಚ್ಚಾಗುತ್ತದೆ", "is_correct": True},
                                {"id": "opt_p15_c", "text": "It stops immediately", "text_kn": "ತಕ್ಷಣ ನಿಲ್ಲುತ್ತದೆ", "is_correct": False},
                                {"id": "opt_p15_d", "text": "It stays at zero", "text_kn": "ಶೂನ್ಯದಲ್ಲಿಯೇ ಇರುತ್ತದೆ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_photo_16",
                            "topic_id": "sci_photo",
                            "skill_id": "skill_photo_factors",
                            "difficulty": "hard",
                            "question_text": "During which process inside green leaf cells is solar energy split from water molecules (H2O) releasing oxygen?",
                            "question_text_kn": "ದ್ಯುತಿಸಂಶ್ಲೇಷಣೆಯ ಯಾವ ಹಂತದಲ್ಲಿ ನೀರಿನ ಅಣುಗಳು ಒಡೆದು ಆಮ್ಲಜನಕ ಬಿಡುಗಡೆಯಾಗುತ್ತದೆ?",
                            "illustration_type": "water_splitting",
                            "illustration_data": "photolysis",
                            "explanation": "Photolysis of water (splitting by light energy) occurs in the light reaction, releasing O2 gas.",
                            "explanation_kn": "ಬೆಳಕಿನ ಕ್ರಿಯೆಯಲ್ಲಿ (Photolysis) ನೀರಿನ ಅಣುಗಳು ವಿಭಜನೆಗೊಂಡು ಆಮ್ಲಜನಕ ಬಿಡುಗಡೆಯಾಗುತ್ತದೆ.",
                            "hint": "Photo (light) + lysis (splitting).",
                            "hint_kn": "ಬೆಳಕಿನಿಂದ ನೀರಿನ ವಿಭಜನೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_p16_a", "text": "Dark reaction", "text_kn": "ಕತ್ತಲೆಯ ಕ್ರಿಯೆ", "is_correct": False},
                                {"id": "opt_p16_b", "text": "Photolysis in light reaction", "text_kn": "ಬೆಳಕಿನ ಕ್ರಿಯೆಯಲ್ಲಿ ನೀರಿನ ವಿಭಜನೆ (Photolysis)", "is_correct": True},
                                {"id": "opt_p16_c", "text": "Root absorption", "text_kn": "ಬೇರಿನ ಹೀರಿಕೊಳ್ಳುವಿಕೆ", "is_correct": False},
                                {"id": "opt_p16_d", "text": "Transpiration", "text_kn": "ಭಾಷ್ಪವಿಸರ್ಜನೆ", "is_correct": False}
                            ]
                        }
                    ]
                },
                {
                    "id": "sci_plants",
                    "subject_id": "science_6",
                    "title": "Parts of Plants",
                    "title_kn": "ಸಸ್ಯದ ಭಾಗಗಳು (Parts of Plants)",
                    "description": "Learn the roles of roots, stems, leaves, flowers, and seeds.",
                    "description_kn": "ಬೇರು, ಕಾಂಡ, ಎಲೆ, ಹೂವು ಮತ್ತು ಬೀಜಗಳ ಕಾರ್ಯಗಳನ್ನು ತಿಳಿಯಿರಿ.",
                    "order_index": 2,
                    "skills": [
                        {"id": "skill_plant_organs", "name": "Plant Organs & Functions", "name_kn": "ಸಸ್ಯದ ಅಂಗಗಳು ಮತ್ತು ಕಾರ್ಯಗಳು", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [],
                    "lessons": [
                        {
                            "id": "lesson_plants_1",
                            "topic_id": "sci_plants",
                            "skill_id": "skill_plant_organs",
                            "title": "Structure of a Plant",
                            "title_kn": "ಸಸ್ಯದ ರಚನೆ",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Roots and Shoots",
                                    "title_kn": "ಬೇರು ಮತ್ತು ಕಾಂಡದ ವ್ಯವಸ್ಥೆ",
                                    "body": "A plant consists of two main systems: Root system (underground) and Shoot system (above ground including stem, leaves, flowers, and fruits).",
                                    "body_kn": "ಸಸ್ಯವು ಎರಡು ಮುಖ್ಯ ವ್ಯವಸ್ಥೆಗಳನ್ನು ಹೊಂದಿದೆ: ಬೇರಿನ ವ್ಯವಸ್ಥೆ (ಮಣ್ಣಿನ ಕೆಳಗೆ) ಮತ್ತು ಕಾಂಡದ ವ್ಯವಸ್ಥೆ (ಮಣ್ಣಿನ ಮೇಲೆ ಕಾಂಡ, ಎಲೆ, ಹೂವು, ಹಣ್ಣುಗಳು).",
                                    "visual_type": "plant_anatomy",
                                    "visual_data": {"root": True, "shoot": True}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        {
                            "id": "q_plants_01",
                            "topic_id": "sci_plants",
                            "skill_id": "skill_plant_organs",
                            "difficulty": "easy",
                            "question_text": "Which part of the plant develops into a fruit after fertilization?",
                            "question_text_kn": "ಫಲೀಕರಣದ ನಂತರ ಸಸ್ಯದ ಯಾವ ಭಾಗವು ಹಣ್ಣಾಗಿ ಬದಲಾಗುತ್ತದೆ?",
                            "illustration_type": "flower_fruit",
                            "illustration_data": "ovary",
                            "explanation": "The ovary of the flower matures into a fruit containing seeds.",
                            "explanation_kn": "ಹೂವಿನ ಅಂಡಾಶಯವು (Ovary) ಪಕ್ವಗೊಂಡು ಬೀಜಗಳನ್ನು ಹೊಂದಿರುವ ಹಣ್ಣಾಗುತ್ತದೆ.",
                            "hint": "It grows from the flower.",
                            "hint_kn": "ಹೂವಿನ ಪ್ರಮುಖ ಭಾಗ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_pl_01_a", "text": "Root", "text_kn": "ಬೇರು", "is_correct": False},
                                {"id": "opt_pl_01_b", "text": "Flower (Ovary)", "text_kn": "ಹೂವು (ಅಂಡಾಶಯ)", "is_correct": True},
                                {"id": "opt_pl_01_c", "text": "Leaf", "text_kn": "ಎಲೆ", "is_correct": False},
                                {"id": "opt_pl_01_d", "text": "Bark", "text_kn": "ತೊಗಟೆ", "is_correct": False}
                            ]
                        }
                    ]
                },
                {
                    "id": "sci_solar",
                    "subject_id": "science_6",
                    "title": "Solar System",
                    "title_kn": "ಸೌರವ್ಯೂಹ (Solar System)",
                    "description": "Explore the Sun, 8 planets, moons, and our place in space.",
                    "description_kn": "ಸೂರ್ಯ, 8 ಗ್ರಹಗಳು, ಉಪಗ್ರಹಗಳು ಮತ್ತು ಬಾಹ್ಯಾಕಾಶವನ್ನು ಅನ್ವೇಷಿಸಿ.",
                    "order_index": 3,
                    "skills": [
                        {"id": "skill_solar_planets", "name": "Planets in Solar System", "name_kn": "ಸೌರವ್ಯೂಹದ ಗ್ರಹಗಳು", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [],
                    "lessons": [
                        {
                            "id": "lesson_solar_1",
                            "topic_id": "sci_solar",
                            "skill_id": "skill_solar_planets",
                            "title": "Our Sun and 8 Planets",
                            "title_kn": "ನಮ್ಮ ಸೂರ್ಯ ಮತ್ತು 8 ಗ್ರಹಗಳು",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "The Solar Family",
                                    "title_kn": "ಸೌರ ಕುಟುಂಬ",
                                    "body": "The Solar System consists of the Sun at the center and 8 planets revolving around it: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, and Neptune.",
                                    "body_kn": "ಸೌರವ್ಯೂಹದಲ್ಲಿ ಸೂರ್ಯನು ಮಧ್ಯದಲ್ಲಿದ್ದು, ಅದರ ಸುತ್ತ 8 ಗ್ರಹಗಳು ಪರಿಭ್ರಮಿಸುತ್ತವೆ: ಬುಧ, ಶುಕ್ರ, ಭೂಮಿ, ಮಂಗಳ, ಗುರು, ಶನಿ, ಯುರೇನಸ್ ಮತ್ತು ನೆಪ್ಚೂನ್.",
                                    "visual_type": "solar_diagram",
                                    "visual_data": {"planets": 8, "star": "Sun"}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        {
                            "id": "q_solar_01",
                            "topic_id": "sci_solar",
                            "skill_id": "skill_solar_planets",
                            "difficulty": "easy",
                            "question_text": "Which planet is known as the 'Red Planet'?",
                            "question_text_kn": "ಯಾವ ಗ್ರಹವನ್ನು 'ಕೆಂಪು ಗ್ರಹ' ಎಂದು ಕರೆಯಲಾಗುತ್ತದೆ?",
                            "illustration_type": "mars",
                            "illustration_data": "red_planet",
                            "explanation": "Mars appears red due to iron oxide (rust) on its surface.",
                            "explanation_kn": "ಮಂಗಳ ಗ್ರಹದ ಮೇಲ್ಮೈಯಲ್ಲಿ ಕಬ್ಬಿಣದ ಆಕ್ಸೈಡ್ ಹೆಚ್ಚಿರುವುದರಿಂದ ಅದು ಕೆಂಪಾಗಿ ಕಾಣುತ್ತದೆ.",
                            "hint": "Fourth planet from the Sun.",
                            "hint_kn": "ಸೂರ್ಯನಿಂದ ನಾಲ್ಕನೇ ಗ್ರಹ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_sol_01_a", "text": "Jupiter", "text_kn": "ಗುರು", "is_correct": False},
                                {"id": "opt_sol_01_b", "text": "Mars", "text_kn": "ಮಂಗಳ", "is_correct": True},
                                {"id": "opt_sol_01_c", "text": "Venus", "text_kn": "ಶುಕ್ರ", "is_correct": False},
                                {"id": "opt_sol_01_d", "text": "Saturn", "text_kn": "ಶನಿ", "is_correct": False}
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "id": "english_6",
            "class_id": "class_6",
            "name": "English",
            "name_kn": "ಇಂಗ್ಲಿಷ್ (English)",
            "icon_name": "menu_book",
            "color_hex": "#0EA5E9",
            "order_index": 3,
            "topics": [
                {
                    "id": "eng_nouns",
                    "subject_id": "english_6",
                    "title": "Nouns",
                    "title_kn": "ನಾಮಪದಗಳು (Nouns)",
                    "description": "Learn names of persons, places, animals, things, and ideas.",
                    "description_kn": "ವ್ಯಕ್ತಿ, ಸ್ಥಳ, ಪ್ರಾಣಿ, ವಸ್ತು ಮತ್ತು ಕಲ್ಪನೆಗಳ ಹೆಸರುಗಳನ್ನು ಕಲಿಯಿರಿ.",
                    "order_index": 1,
                    "skills": [
                        {"id": "skill_noun_identification", "name": "Identifying Common Nouns", "name_kn": "ಸಾಮಾನ್ಯ ನಾಮಪದ ಗುರುತಿಸುವಿಕೆ", "initial_mastery": 0.30},
                        {"id": "skill_noun_proper", "name": "Proper and Collective Nouns", "name_kn": "ಅಂಕಿತನಾಮ ಮತ್ತು ಸಮೂಹವಾಚಕ ನಾಮಪದಗಳು", "initial_mastery": 0.30},
                        {"id": "skill_noun_abstract", "name": "Abstract and Countable Nouns", "name_kn": "ಭಾವವಾಚಕ ಮತ್ತು ಎಣಿಸಬಹುದಾದ ನಾಮಪದಗಳು", "initial_mastery": 0.30},
                        {"id": "skill_noun_plural_irregular", "name": "Irregular Plurals and Usage", "name_kn": "ವಿಶೇಷ ಬಹುವಚನಗಳು ಮತ್ತು ವಾಕ್ಯ ಪ್ರಯೋಗ", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [
                        {"skill_id": "skill_noun_proper", "prerequisite_skill_id": "skill_noun_identification"},
                        {"skill_id": "skill_noun_abstract", "prerequisite_skill_id": "skill_noun_proper"},
                        {"skill_id": "skill_noun_plural_irregular", "prerequisite_skill_id": "skill_noun_abstract"}
                    ],
                    "lessons": [
                        {
                            "id": "lesson_noun_1",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_identification",
                            "title": "What is a Noun?",
                            "title_kn": "ನಾಮಪದ ಎಂದರೇನು?",
                            "audio_en_path": "assets/audio/en/english/eng_nouns_intro.mp3",
                            "audio_kn_path": "assets/audio/kn/english/eng_nouns_intro.mp3",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Naming Words",
                                    "title_kn": "ಹೆಸರಿಸುವ ಪದಗಳು",
                                    "body": "A noun is a naming word. It names a person (Raju, Teacher), a place (Bengaluru, School), an animal (Cow, Elephant), a thing (Book, Pen), or an idea/feeling (Courage, Joy).",
                                    "body_kn": "ಯಾವುದೇ ವ್ಯಕ್ತಿ, ಸ್ಥಳ, ಪ್ರಾಣಿ, ವಸ್ತು ಅಥವಾ ಭಾವನೆಯನ್ನು ಹೆಸರಿಸುವ ಪದವನ್ನು ನಾಮಪದ (Noun) ಎನ್ನುತ್ತಾರೆ. ಉದಾಹರಣೆಗೆ: ರಾಜು, ಶಾಲೆ, ಹಸು, ಪುಸ್ತಕ, ಧೈರ್ಯ.",
                                    "visual_type": "noun_categories",
                                    "visual_data": {"person": "Doctor 👨‍⚕️", "place": "Village 🏡", "thing": "Pencil ✏️", "animal": "Lion 🦁"}
                                },
                                {
                                    "title": "Types of Nouns",
                                    "title_kn": "ನಾಮಪದಗಳ ವಿಧಗಳು",
                                    "body": "1. Common Noun: general names (boy, city, river)\n2. Proper Noun: special names that always start with a capital letter (Ramesh, Mysuru, Ganga)\n3. Collective Noun: group names (flock of birds, team of players).",
                                    "body_kn": "1. ಸಾಮಾನ್ಯ ನಾಮಪದ: ಹುಡುಗ, ಊರು, ನದಿ\n2. ಅಂಕಿತ ನಾಮಪದ (Proper Noun): ನಿರ್ದಿಷ್ಟ ಹೆಸರುಗಳು (ರಮೇಶ್, ಮೈಸೂರು, ಗಂಗಾ)\n3. ಸಮೂಹ ನಾಮಪದ: ಗುಂಪಿನ ಹೆಸರು (ಹಕ್ಕಿಗಳ ಹಿಂಡು, ತಂಡ).",
                                    "visual_type": "type_card",
                                    "visual_data": {"types": ["Common", "Proper", "Collective", "Abstract"]}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        # 16 questions: 5 Easy, 6 Medium, 5 Hard
                        {
                            "id": "q_noun_01",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_identification",
                            "difficulty": "easy",
                            "question_text": "Identify the noun in this sentence: 'The boy plays with a football.'",
                            "question_text_kn": "ಈ ವಾಕ್ಯದಲ್ಲಿರುವ ನಾಮಪದವನ್ನು ಗುರುತಿಸಿ: 'The boy plays with a football.'",
                            "illustration_type": "boy_ball",
                            "illustration_data": "boy",
                            "explanation": "'boy' and 'football' are nouns naming a person and a thing. Here 'boy' is the correct option.",
                            "explanation_kn": "'boy' (ವ್ಯಕ್ತಿ) ಮತ್ತು 'football' (ವಸ್ತು) ನಾಮಪದಗಳಾಗಿವೆ.",
                            "hint": "Who is playing?",
                            "hint_kn": "ಯಾರು ಆಟವಾಡುತ್ತಿದ್ದಾರೆ?",
                            "audio_en_path": "assets/audio/en/english/eng_nouns_q1.mp3",
                            "audio_kn_path": "assets/audio/kn/english/eng_nouns_q1.mp3",
                            "options": [
                                {"id": "opt_n01_a", "text": "plays", "text_kn": "plays (ಆಡುತ್ತಾನೆ - ಕ್ರಿಯಾಪದ)", "is_correct": False},
                                {"id": "opt_n01_b", "text": "boy", "text_kn": "boy (ಹುಡುಗ - ನಾಮಪದ)", "is_correct": True},
                                {"id": "opt_n01_c", "text": "with", "text_kn": "with", "is_correct": False},
                                {"id": "opt_n01_d", "text": "the", "text_kn": "the", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_02",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_identification",
                            "difficulty": "easy",
                            "question_text": "Which of these words is a noun naming a place?",
                            "question_text_kn": "ಇವುಗಳಲ್ಲಿ ಸ್ಥಳವನ್ನು ಸೂಚಿಸುವ ನಾಮಪದ ಯಾವುದು?",
                            "illustration_type": "school_icon",
                            "illustration_data": "place",
                            "explanation": "'School' is a noun that names a place.",
                            "explanation_kn": "'School' (ಶಾಲೆ) ಸ್ಥಳವನ್ನು ಹೆಸರಿಸುವ ನಾಮಪದವಾಗಿದೆ.",
                            "hint": "A place where you go to study.",
                            "hint_kn": "ನೀವು ಕಲಿಯಲು ಹೋಗುವ ಜಾಗ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n02_a", "text": "Run", "text_kn": "Run (ಓಡು)", "is_correct": False},
                                {"id": "opt_n02_b", "text": "School", "text_kn": "School (ಶಾಲೆ)", "is_correct": True},
                                {"id": "opt_n02_c", "text": "Quickly", "text_kn": "Quickly (ಬೇಗನೆ)", "is_correct": False},
                                {"id": "opt_n02_d", "text": "Bright", "text_kn": "Bright (ಪ್ರಕಾಶಮಾನ)", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_03",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_proper",
                            "difficulty": "easy",
                            "question_text": "Proper nouns must always begin with which letter type?",
                            "question_text_kn": "ಅಂಕಿತನಾಮಗಳು (Proper nouns) ಯಾವಾಗಲೂ ಯಾವ ಅಕ್ಷರದಿಂದ ಪ್ರಾರಂಭವಾಗಬೇಕು?",
                            "illustration_type": "capital_letter",
                            "illustration_data": "ABC",
                            "explanation": "Proper nouns always begin with a Capital Letter (e.g., India, Raju).",
                            "explanation_kn": "ಅಂಕಿತನಾಮಗಳು ಯಾವಾಗಲೂ ದೊಡ್ಡಕ್ಷರದಿಂದ (Capital Letter) ಪ್ರಾರಂಭವಾಗಬೇಕು.",
                            "hint": "Big or uppercase letter.",
                            "hint_kn": "ದೊಡ್ಡಕ್ಷರ (ಕ್ಯಾಪಿಟಲ್ ಲೆಟರ್).",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n03_a", "text": "Small letter", "text_kn": "ಸಣ್ಣಕ್ಷರ (Small letter)", "is_correct": False},
                                {"id": "opt_n03_b", "text": "Capital letter", "text_kn": "ದೊಡ್ಡಕ್ಷರ (Capital letter)", "is_correct": True},
                                {"id": "opt_n03_c", "text": "Number", "text_kn": "ಅಂಕಿ", "is_correct": False},
                                {"id": "opt_n03_d", "text": "Symbol", "text_kn": "ಚಿಹ್ನೆ", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_04",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_identification",
                            "difficulty": "easy",
                            "question_text": "Find the noun naming an animal in: 'The dog barked loudly.'",
                            "question_text_kn": "ಈ ವಾಕ್ಯದಲ್ಲಿ ಪ್ರಾಣಿಯ ಹೆಸರಾಗಿರುವ ನಾಮಪದವನ್ನು ಗುರುತಿಸಿ: 'The dog barked loudly.'",
                            "illustration_type": "dog",
                            "illustration_data": "dog",
                            "explanation": "'dog' is a noun naming an animal.",
                            "explanation_kn": "'dog' (ನಾಯಿ) ಪ್ರಾಣಿಯನ್ನು ಹೆಸರಿಸುವ ನಾಮಪದವಾಗಿದೆ.",
                            "hint": "Who was barking?",
                            "hint_kn": "ಬೊಗಳುತ್ತಿದ್ದ ಪ್ರಾಣಿ ಯಾವುದು?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n04_a", "text": "barked", "text_kn": "barked", "is_correct": False},
                                {"id": "opt_n04_b", "text": "dog", "text_kn": "dog", "is_correct": True},
                                {"id": "opt_n04_c", "text": "loudly", "text_kn": "loudly", "is_correct": False},
                                {"id": "opt_n04_d", "text": "The", "text_kn": "The", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_05",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_identification",
                            "difficulty": "easy",
                            "question_text": "Which of the following is a common noun?",
                            "question_text_kn": "ಇವುಗಳಲ್ಲಿ ಸಾಮಾನ್ಯ ನಾಮಪದ (Common noun) ಯಾವುದು?",
                            "illustration_type": "river",
                            "illustration_data": "common",
                            "explanation": "'river' is a common noun because it refers to any river generally, unlike specific names like 'Kaveri'.",
                            "explanation_kn": "'river' ಸಾಮಾನ್ಯ ನಾಮಪದ, ಏಕೆಂದರೆ ಇದು ನಿರ್ದಿಷ್ಟ ನದಿಯ ಹೆಸರಲ್ಲದೆ ಯಾವುದೇ ನದಿಗೆ ಅನ್ವಯಿಸುತ್ತದೆ.",
                            "hint": "It is not a specific capitalized name.",
                            "hint_kn": "ಇದು ನಿರ್ದಿಷ್ಟ ಹೆಸರಲ್ಲದೆ ಸಾಮಾನ್ಯ ವರ್ಗವನ್ನು ಸೂಚಿಸುತ್ತದೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n05_a", "text": "Karnataka", "text_kn": "Karnataka (ಅಂಕಿತನಾಮ)", "is_correct": False},
                                {"id": "opt_n05_b", "text": "river", "text_kn": "river (ಸಾಮಾನ್ಯ ನಾಮಪದ)", "is_correct": True},
                                {"id": "opt_n05_c", "text": "Himalayas", "text_kn": "Himalayas (ಅಂಕಿತನಾಮ)", "is_correct": False},
                                {"id": "opt_n05_d", "text": "Monday", "text_kn": "Monday (ಅಂಕಿತನಾಮ)", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_06",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_proper",
                            "difficulty": "medium",
                            "question_text": "What is the collective noun for a group of lions?",
                            "question_text_kn": "ಸಿಂಹಗಳ ಗುಂಪಿಗೆ ಬಳಸುವ ಸಮೂಹ ನಾಮಪದ (Collective noun) ಯಾವುದು?",
                            "illustration_type": "lions",
                            "illustration_data": "pride",
                            "explanation": "A group of lions is called a 'pride'.",
                            "explanation_kn": "ಸಿಂಹಗಳ ಗುಂಪನ್ನು 'a pride of lions' ಎಂದು ಕರೆಯುತ್ತಾರೆ.",
                            "hint": "A _____ of lions.",
                            "hint_kn": "ಇದು ಹೆಮ್ಮೆ ಎಂಬ ಪದದಂತೆಯೇ ಇರುತ್ತದೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n06_a", "text": "Herd", "text_kn": "Herd", "is_correct": False},
                                {"id": "opt_n06_b", "text": "Pride", "text_kn": "Pride", "is_correct": True},
                                {"id": "opt_n06_c", "text": "Pack", "text_kn": "Pack", "is_correct": False},
                                {"id": "opt_n06_d", "text": "Flock", "text_kn": "Flock", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_07",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_proper",
                            "difficulty": "medium",
                            "question_text": "Complete the collective noun phrase: 'A _____ of keys.'",
                            "question_text_kn": "ಸಮೂಹ ನಾಮಪದವನ್ನು ಪೂರ್ಣಗೊಳಿಸಿ: 'A _____ of keys.'",
                            "illustration_type": "keys",
                            "illustration_data": "bunch",
                            "explanation": "A group of keys held together is called a 'bunch'.",
                            "explanation_kn": "ಕೀಲಿಗಳ ಗೊಂಚಲನ್ನು 'a bunch of keys' ಎಂದು ಕರೆಯುತ್ತಾರೆ.",
                            "hint": "Think of a bunch of grapes or keys.",
                            "hint_kn": "ಕೀಲಿಗಳ ಗೊಂಚಲು.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n07_a", "text": "Fleet", "text_kn": "Fleet", "is_correct": False},
                                {"id": "opt_n07_b", "text": "Bunch", "text_kn": "Bunch", "is_correct": True},
                                {"id": "opt_n07_c", "text": "Swarm", "text_kn": "Swarm", "is_correct": False},
                                {"id": "opt_n07_d", "text": "Crowd", "text_kn": "Crowd", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_08",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_abstract",
                            "difficulty": "medium",
                            "question_text": "Which of these words is an Abstract Noun (a quality or feeling)?",
                            "question_text_kn": "ಇವುಗಳಲ್ಲಿ ಭಾವವಾಚಕ ನಾಮಪದ (Abstract Noun - ಗುಣ ಅಥವಾ ಭಾವನೆ) ಯಾವುದು?",
                            "illustration_type": "heart",
                            "illustration_data": "honesty",
                            "explanation": "'Honesty' is an abstract noun because it is a quality you can understand with your mind, but cannot touch or see physically.",
                            "explanation_kn": "'Honesty' (ಪ್ರಾಮಾಣಿಕತೆ) ಒಂದು ಸದ್ಗುಣವಾಗಿದ್ದು ಭಾವವಾಚಕ ನಾಮಪದವಾಗಿದೆ.",
                            "hint": "You cannot physically hold it in your hand.",
                            "hint_kn": "ಇದನ್ನು ಕೈಯಲ್ಲಿ ಮುಟ್ಟಲು ಸಾಧ್ಯವಿಲ್ಲ, ಕೇವಲ ಅನುಭವಿಸಲು ಅಥವಾ ತಿಳಿಯಲು ಸಾಧ್ಯ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n08_a", "text": "Chair", "text_kn": "Chair (ಕುರ್ಚಿ)", "is_correct": False},
                                {"id": "opt_n08_b", "text": "Honesty", "text_kn": "Honesty (ಪ್ರಾಮಾಣಿಕತೆ)", "is_correct": True},
                                {"id": "opt_n08_c", "text": "Apple", "text_kn": "Apple (ಸೇಬು)", "is_correct": False},
                                {"id": "opt_n08_d", "text": "River", "text_kn": "River (ನದಿ)", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_09",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_abstract",
                            "difficulty": "medium",
                            "question_text": "Which of these nouns is Uncountable?",
                            "question_text_kn": "ಇವುಗಳಲ್ಲಿ ಎಣಿಸಲಾಗದ ನಾಮಪದ (Uncountable Noun) ಯಾವುದು?",
                            "illustration_type": "milk_glass",
                            "illustration_data": "milk",
                            "explanation": "'Milk' is a liquid and cannot be counted as 1, 2, 3 individual items (unlike books or pens).",
                            "explanation_kn": "'Milk' (ಹಾಲು) ದ್ರವವಾಗಿದ್ದು, ಅದನ್ನು ಒಂದೊಂದು ಹನಿ ಅಥವಾ ವಸ್ತುವಾಗಿ ಎಣಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.",
                            "hint": "You measure it in liters, not by counting 1, 2, 3.",
                            "hint_kn": "ಇದನ್ನು ಲೀಟರ್‌ಗಳಲ್ಲಿ ಅಳೆಯುತ್ತೇವೆ, ಒಂದೆರಡು ಎಂದು ಎಣಿಸುವುದಿಲ್ಲ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n09_a", "text": "Book", "text_kn": "Book (ಪುಸ್ತಕ)", "is_correct": False},
                                {"id": "opt_n09_b", "text": "Milk", "text_kn": "Milk (ಹಾಲು)", "is_correct": True},
                                {"id": "opt_n09_c", "text": "Pencil", "text_kn": "Pencil (ಪೆನ್ಸಿಲ್)", "is_correct": False},
                                {"id": "opt_n09_d", "text": "Bicycle", "text_kn": "Bicycle (ಸೈಕಲ್)", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_10",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_plural_irregular",
                            "difficulty": "medium",
                            "question_text": "What is the plural form of 'child'?",
                            "question_text_kn": "'Child' (ಮಗು) ಪದದ ಬಹುವಚನ ಯಾವುದು?",
                            "illustration_type": "children",
                            "illustration_data": "plural",
                            "explanation": "The irregular plural of 'child' is 'children' (we do not add 's').",
                            "explanation_kn": "'Child' ಪದದ ಸರಿಯಾದ ಬಹುವಚನ 'children'.",
                            "hint": "Do not say 'childs'.",
                            "hint_kn": "'s' ಸೇರಿಸಬೇಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n10_a", "text": "Childs", "text_kn": "Childs", "is_correct": False},
                                {"id": "opt_n10_b", "text": "Children", "text_kn": "Children", "is_correct": True},
                                {"id": "opt_n10_c", "text": "Childrens", "text_kn": "Childrens", "is_correct": False},
                                {"id": "opt_n10_d", "text": "Childes", "text_kn": "Childes", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_11",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_plural_irregular",
                            "difficulty": "medium",
                            "question_text": "What is the plural form of 'leaf'?",
                            "question_text_kn": "'Leaf' (ಎಲೆ) ಪದದ ಬಹುವಚನ ಯಾವುದು?",
                            "illustration_type": "leaves",
                            "illustration_data": "leaves",
                            "explanation": "Nouns ending in 'f' usually change 'f' to 'ves': leaf -> leaves.",
                            "explanation_kn": "'f' ನಿಂದ ಕೊನೆಗೊಳ್ಳುವ ಪದಗಳು ಬಹುವಚನದಲ್ಲಿ 'ves' ಆಗುತ್ತವೆ: leaf -> leaves.",
                            "hint": "Change 'f' to 'ves'.",
                            "hint_kn": "'f' ಬದಲಿಗೆ 'ves' ಬರುತ್ತದೆ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n11_a", "text": "Leafs", "text_kn": "Leafs", "is_correct": False},
                                {"id": "opt_n11_b", "text": "Leaves", "text_kn": "Leaves", "is_correct": True},
                                {"id": "opt_n11_c", "text": "Leafes", "text_kn": "Leafes", "is_correct": False},
                                {"id": "opt_n11_d", "text": "Leavs", "text_kn": "Leavs", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_12",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_abstract",
                            "difficulty": "hard",
                            "question_text": "Which noun in this sentence is an Abstract Noun: 'The soldier fought with immense courage.'?",
                            "question_text_kn": "ಈ ವಾಕ್ಯದಲ್ಲಿರುವ ಭಾವವಾಚಕ ನಾಮಪದ (Abstract Noun) ಯಾವುದು: 'The soldier fought with immense courage.'?",
                            "illustration_type": "soldier_courage",
                            "illustration_data": "courage",
                            "explanation": "'Courage' is an abstract noun representing bravery.",
                            "explanation_kn": "'Courage' (ಧೈರ್ಯ) ಭಾವವಾಚಕ ನಾಮಪದವಾಗಿದೆ.",
                            "hint": "A brave feeling or quality.",
                            "hint_kn": "ಶೌರ್ಯ ಅಥವಾ ಧೈರ್ಯವನ್ನು ಸೂಚಿಸುವ ಪದ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n12_a", "text": "soldier", "text_kn": "soldier (ಸಾಮಾನ್ಯ ನಾಮಪದ)", "is_correct": False},
                                {"id": "opt_n12_b", "text": "courage", "text_kn": "courage (ಭಾವವಾಚಕ ನಾಮಪದ)", "is_correct": True},
                                {"id": "opt_n12_c", "text": "fought", "text_kn": "fought (ಕ್ರಿಯಾಪದ)", "is_correct": False},
                                {"id": "opt_n12_d", "text": "immense", "text_kn": "immense (ವಿಶೇಷಣ)", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_13",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_plural_irregular",
                            "difficulty": "hard",
                            "question_text": "What is the irregular plural form of 'mouse'?",
                            "question_text_kn": "'Mouse' (ಇಲಿ) ಪದದ ಬಹುವಚನ ರೂಪ ಯಾವುದು?",
                            "illustration_type": "mice",
                            "illustration_data": "mice",
                            "explanation": "The plural of 'mouse' is 'mice'.",
                            "explanation_kn": "'Mouse' ಪದದ ಬಹುವಚನ ರೂಪ 'mice'.",
                            "hint": "Rhymes with 'ice' or 'nice'.",
                            "hint_kn": "'mouses' ಅಲ್ಲ, ಸರಿಯಾದ ಪದ ಆಯ್ಕೆ ಮಾಡಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n13_a", "text": "Mouses", "text_kn": "Mouses", "is_correct": False},
                                {"id": "opt_n13_b", "text": "Mice", "text_kn": "Mice", "is_correct": True},
                                {"id": "opt_n13_c", "text": "Mices", "text_kn": "Mices", "is_correct": False},
                                {"id": "opt_n13_d", "text": "Mousees", "text_kn": "Mousees", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_14",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_proper",
                            "difficulty": "hard",
                            "question_text": "How many nouns are present in this sentence: 'Kavita and her brother visited the Mysore Palace on Sunday.'?",
                            "question_text_kn": "ಈ ವಾಕ್ಯದಲ್ಲಿ ಒಟ್ಟು ಎಷ್ಟು ನಾಮಪದಗಳಿವೆ: 'Kavita and her brother visited the Mysore Palace on Sunday.'?",
                            "illustration_type": "palace",
                            "illustration_data": "count_nouns",
                            "explanation": "There are 4 nouns: 1. Kavita (Proper), 2. brother (Common), 3. Mysore Palace (Proper), 4. Sunday (Proper).",
                            "explanation_kn": "ಒಟ್ಟು 4 ನಾಮಪದಗಳಿವೆ: Kavita, brother, Mysore Palace, Sunday.",
                            "hint": "Count names of people, family title, landmark, and day.",
                            "hint_kn": "ವ್ಯಕ್ತಿಯ ಹೆಸರು, ಸಂಬಂಧ, ಪ್ರಸಿದ್ಧ ಸ್ಥಳ ಮತ್ತು ವಾರದ ದಿನವನ್ನು ಎಣಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n14_a", "text": "2", "text_kn": "2", "is_correct": False},
                                {"id": "opt_n14_b", "text": "3", "text_kn": "3", "is_correct": False},
                                {"id": "opt_n14_c", "text": "4", "text_kn": "4", "is_correct": True},
                                {"id": "opt_n14_d", "text": "5", "text_kn": "5", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_15",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_abstract",
                            "difficulty": "hard",
                            "question_text": "What abstract noun is formed from the adjective 'kind'?",
                            "question_text_kn": "'Kind' (ದಯಾಳು) ವಿಶೇಷಣದಿಂದ ರೂಪುಗೊಳ್ಳುವ ಭಾವವಾಚಕ ನಾಮಪದ ಯಾವುದು?",
                            "illustration_type": "kindness",
                            "illustration_data": "kindness",
                            "explanation": "Adding suffix '-ness' to 'kind' gives the abstract noun 'Kindness'.",
                            "explanation_kn": "'Kind' ಗೆ '-ness' ಪ್ರತ್ಯಯ ಸೇರಿಸಿದಾಗ 'Kindness' (ದಯೆ) ಎಂಬ ನಾಮಪದವಾಗುತ್ತದೆ.",
                            "hint": "Add '-ness' at the end.",
                            "hint_kn": "ಕೊನೆಯಲ್ಲಿ '-ness' ಸೇರಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n15_a", "text": "Kindly", "text_kn": "Kindly (ಕ್ರಿಯಾವಿಶೇಷಣ)", "is_correct": False},
                                {"id": "opt_n15_b", "text": "Kindness", "text_kn": "Kindness (ದಯೆ - ಭಾವವಾಚಕ ನಾಮಪದ)", "is_correct": True},
                                {"id": "opt_n15_c", "text": "Kinder", "text_kn": "Kinder", "is_correct": False},
                                {"id": "opt_n15_d", "text": "Kinded", "text_kn": "Kinded", "is_correct": False}
                            ]
                        },
                        {
                            "id": "q_noun_16",
                            "topic_id": "eng_nouns",
                            "skill_id": "skill_noun_plural_irregular",
                            "difficulty": "hard",
                            "question_text": "Which noun has the exact same form in both singular and plural?",
                            "question_text_kn": "ಏಕವಚನ ಮತ್ತು ಬಹುವಚನ ಎರಡರಲ್ಲೂ ಒಂದೇ ರೀತಿಯಾಗಿರುವ ನಾಮಪದ ಯಾವುದು?",
                            "illustration_type": "sheep",
                            "illustration_data": "sheep",
                            "explanation": "'Sheep' remains 'sheep' in both singular and plural (1 sheep, 10 sheep). We do not say 'sheeps'.",
                            "explanation_kn": "'Sheep' (ಕುರಿ) ಪದವು ಏಕವಚನ ಮತ್ತು ಬಹುವಚನ ಎರಡರಲ್ಲೂ 'sheep' ಎಂದೇ ಇರುತ್ತದೆ.",
                            "hint": "A woolly farm animal.",
                            "hint_kn": "ಉಣ್ಣೆ ನೀಡುವ ಪ್ರಾಣಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_n16_a", "text": "Dog", "text_kn": "Dog (ಬಹುವಚನ: dogs)", "is_correct": False},
                                {"id": "opt_n16_b", "text": "Sheep", "text_kn": "Sheep (ಬಹುವಚನವೂ sheep)", "is_correct": True},
                                {"id": "opt_n16_c", "text": "Cat", "text_kn": "Cat (ಬಹುವಚನ: cats)", "is_correct": False},
                                {"id": "opt_n16_d", "text": "Cow", "text_kn": "Cow (ಬಹುವಚನ: cows)", "is_correct": False}
                            ]
                        }
                    ]
                },
                {
                    "id": "eng_verbs",
                    "subject_id": "english_6",
                    "title": "Verbs",
                    "title_kn": "ಕ್ರಿಯಾಪದಗಳು (Verbs)",
                    "description": "Learn action words, helping verbs, and tenses.",
                    "description_kn": "ಕ್ರಿಯೆಯನ್ನು ಸೂಚಿಸುವ ಪದಗಳು ಮತ್ತು ಕಾಲಗಳನ್ನು ಕಲಿಯಿರಿ.",
                    "order_index": 2,
                    "skills": [
                        {"id": "skill_verb_action", "name": "Action Verbs", "name_kn": "ಕ್ರಿಯಾಪದಗಳ ಪರಿಚಯ", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [],
                    "lessons": [
                        {
                            "id": "lesson_verb_1",
                            "topic_id": "eng_verbs",
                            "skill_id": "skill_verb_action",
                            "title": "What is a Verb?",
                            "title_kn": "ಕ್ರಿಯಾಪದ ಎಂದರೇನು?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Action Words",
                                    "title_kn": "ಕ್ರಿಯೆಯನ್ನು ಸೂಚಿಸುವ ಪದಗಳು",
                                    "body": "A verb describes an action, state, or occurrence. Examples: jump, read, write, sing, eat.",
                                    "body_kn": "ಯಾವುದೇ ಕ್ರಿಯೆಯನ್ನು ಸೂಚಿಸುವ ಪದವನ್ನು ಕ್ರಿಯಾಪದ (Verb) ಎನ್ನುತ್ತಾರೆ. ಉದಾ: ಓಡು, ಓದು, ಬರೆ, ಹಾಡು, ತಿನ್ನು.",
                                    "visual_type": "verb_action",
                                    "visual_data": {"action": "Running 🏃"}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        {
                            "id": "q_verb_01",
                            "topic_id": "eng_verbs",
                            "skill_id": "skill_verb_action",
                            "difficulty": "easy",
                            "question_text": "Which word is a verb: 'The birds fly in the sky.'?",
                            "question_text_kn": "ಈ ವಾಕ್ಯದಲ್ಲಿ ಕ್ರಿಯಾಪದ (Verb) ಯಾವುದು: 'The birds fly in the sky.'?",
                            "illustration_type": "birds_flying",
                            "illustration_data": "fly",
                            "explanation": "'fly' is the action word describing what the birds do.",
                            "explanation_kn": "'fly' (ಹಾರುತ್ತವೆ) ಹಕ್ಕಿಗಳು ಮಾಡುವ ಕ್ರಿಯೆಯನ್ನು ತಿಳಿಸುವ ಕ್ರಿಯಾಪದವಾಗಿದೆ.",
                            "hint": "What do the birds do?",
                            "hint_kn": "ಹಕ್ಕಿಗಳು ಏನು ಮಾಡುತ್ತಿವೆ?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_v01_a", "text": "birds", "text_kn": "birds (ನಾಮಪದ)", "is_correct": False},
                                {"id": "opt_v01_b", "text": "fly", "text_kn": "fly (ಕ್ರಿಯಾಪದ)", "is_correct": True},
                                {"id": "opt_v01_c", "text": "sky", "text_kn": "sky (ನಾಮಪದ)", "is_correct": False},
                                {"id": "opt_v01_d", "text": "in", "text_kn": "in", "is_correct": False}
                            ]
                        }
                    ]
                },
                {
                    "id": "eng_sentences",
                    "subject_id": "english_6",
                    "title": "Sentence Formation",
                    "title_kn": "ವಾಕ್ಯ ರಚನೆ (Sentence Formation)",
                    "description": "Learn Subject + Verb + Object structure and punctuation.",
                    "description_kn": "ಕರ್ತೃ + ಕ್ರಿಯಾಪದ + ಕರ್ಮ ಮತ್ತು ವಿರಾಮಚಿಹ್ನೆಗಳ ನಿಯಮಗಳನ್ನು ಕಲಿಯಿರಿ.",
                    "order_index": 3,
                    "skills": [
                        {"id": "skill_sentence_svo", "name": "Basic S-V-O Structure", "name_kn": "ಮೂಲ ವಾಕ್ಯ ರಚನೆ", "initial_mastery": 0.30}
                    ],
                    "prerequisites": [],
                    "lessons": [
                        {
                            "id": "lesson_sentence_1",
                            "topic_id": "eng_sentences",
                            "skill_id": "skill_sentence_svo",
                            "title": "How to Make a Sentence",
                            "title_kn": "ವಾಕ್ಯ ರಚನೆ ಹೇಗೆ ಮಾಡುವುದು?",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "order_index": 1,
                            "slides": [
                                {
                                    "title": "Subject, Verb, Object",
                                    "title_kn": "ಕರ್ತೃ, ಕ್ರಿಯೆ, ಕರ್ಮ",
                                    "body": "A complete English sentence usually has: Subject (Who) + Verb (Action) + Object (What). Example: 'Raju (Subject) reads (Verb) a book (Object).'",
                                    "body_kn": "ಇಂಗ್ಲಿಷ್ ವಾಕ್ಯದಲ್ಲಿ ಸಾಮಾನ್ಯವಾಗಿ: Subject (ಕರ್ತೃ) + Verb (ಕ್ರಿಯಾಪದ) + Object (ಕರ್ಮ) ಇರುತ್ತದೆ. ಉದಾಹರಣೆ: 'Raju reads a book.'",
                                    "visual_type": "svo_boxes",
                                    "visual_data": {"subject": "Raju", "verb": "reads", "object": "a book"}
                                }
                            ]
                        }
                    ],
                    "questions": [
                        {
                            "id": "q_sent_01",
                            "topic_id": "eng_sentences",
                            "skill_id": "skill_sentence_svo",
                            "difficulty": "easy",
                            "question_text": "Arrange words into a correct sentence: 'mangoes / likes / She'",
                            "question_text_kn": "ಪದಗಳನ್ನು ಸರಿಯಾದ ವಾಕ್ಯವಾಗಿ ಜೋಡಿಸಿ: 'mangoes / likes / She'",
                            "illustration_type": "sentence_order",
                            "illustration_data": "she_likes_mangoes",
                            "explanation": "Subject (She) + Verb (likes) + Object (mangoes).",
                            "explanation_kn": "Subject (She) + Verb (likes) + Object (mangoes).",
                            "hint": "Start with 'She'.",
                            "hint_kn": "'She' ಯಿಂದ ಪ್ರಾರಂಭಿಸಿ.",
                            "audio_en_path": "",
                            "audio_kn_path": "",
                            "options": [
                                {"id": "opt_s01_a", "text": "Likes mangoes she.", "text_kn": "Likes mangoes she.", "is_correct": False},
                                {"id": "opt_s01_b", "text": "She likes mangoes.", "text_kn": "She likes mangoes.", "is_correct": True},
                                {"id": "opt_s01_c", "text": "Mangoes she likes.", "text_kn": "Mangoes she likes.", "is_correct": False},
                                {"id": "opt_s01_d", "text": "She mangoes likes.", "text_kn": "She mangoes likes.", "is_correct": False}
                            ]
                        }
                    ]
                }
            ]
        }
    ]
}

out_path = "D:/ShikshaEdge/android-app/assets/content/class_6_default_pack.json"
os.makedirs(os.path.dirname(out_path), exist_ok=True)
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(content_pack, f, ensure_ascii=False, indent=2)

print(f"Content pack generated successfully at {out_path} with {len(content_pack['subjects'])} subjects.")
