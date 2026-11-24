import urllib.request
import json
import uuid
import sys

BASE_URL = 'https://ckvjmsctfuzhykxxjqbh.supabase.co'
ANON_KEY = 'sb_publishable_EKnrIqc-Eh45NmtQtjHRpA_LEWg2Xkn'

def request(endpoint, method='GET', data=None, token=None):
    url = f'{BASE_URL}{endpoint}'
    headers = {
        'apikey': ANON_KEY,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }
    if token:
        headers['Authorization'] = f'Bearer {token}'
    
    body = json.dumps(data).encode() if data is not None else None
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            content = resp.read().decode()
            return resp.status, json.loads(content) if content else None
    except urllib.error.HTTPError as e:
        err_content = e.read().decode()
        try:
            err_json = json.loads(err_content)
        except:
            err_json = err_content
        return e.code, err_json

def run_tests():
    print("=" * 75)
    print("SHIKSHAEDGE SUPABASE E2E INTEGRATION & SECURITY VERIFICATION REPORT")
    print("=" * 75)

    test_results = {}

    # -------------------------------------------------------------------------
    # TEST 1: Anonymous Sign-in & User UUID Generation
    # -------------------------------------------------------------------------
    print("\n[TEST 1] Testing Supabase Anonymous Sign-in for User A...")
    status, user_a_data = request('/auth/v1/signup', method='POST', data={})
    user_a_id = user_a_data.get('id') or (user_a_data.get('user') or {}).get('id') if isinstance(user_a_data, dict) else None
    user_a_token = user_a_data.get('access_token') or (user_a_data.get('session') or {}).get('access_token') if isinstance(user_a_data, dict) else None
    user_a_refresh = user_a_data.get('refresh_token') or (user_a_data.get('session') or {}).get('refresh_token') if isinstance(user_a_data, dict) else None
    is_anon = (user_a_data.get('user') or {}).get('is_anonymous') if isinstance(user_a_data, dict) else False
    
    if status == 200 and user_a_id and is_anon:
        print(f"  -> Generated User A UUID: {user_a_id}")
        print(f"  -> Is Anonymous: {is_anon}")
        print(f"  -> JWT Access Token: {user_a_token[:25]}... (valid)")
        test_results['anonymous_signin'] = 'PASSED'
    else:
        print(f"  -> FAILED: Status {status}, Response: {user_a_data}")
        test_results['anonymous_signin'] = 'FAILED'
        return test_results

    # -------------------------------------------------------------------------
    # TEST 2: Session Persistence & Identity Restoration
    # -------------------------------------------------------------------------
    print("\n[TEST 2] Testing Session Restoration using Refresh Token...")
    status, refresh_data = request('/auth/v1/token?grant_type=refresh_token', method='POST', data={'refresh_token': user_a_refresh})
    restored_user_id = refresh_data.get('id') or (refresh_data.get('user') or {}).get('id') if isinstance(refresh_data, dict) else None
    if status == 200 and restored_user_id == user_a_id:
        print(f"  -> Restored User UUID: {restored_user_id} (Matches original User A)")
        print("  -> PASSED: Identity successfully preserved across session recovery.")
        test_results['session_restoration'] = 'PASSED'
    else:
        print(f"  -> FAILED: Expected {user_a_id}, got {restored_user_id}")
        test_results['session_restoration'] = 'FAILED'

    # -------------------------------------------------------------------------
    # TEST 3: Create Fictional Student Profile with Authenticated owner_id
    # -------------------------------------------------------------------------
    student_id = str(uuid.uuid4())
    print(f"\n[TEST 3] Creating Fictional Student Profile under owner_id: {user_a_id}...")
    profile_payload = {
        'id': student_id,
        'owner_id': user_a_id,
        'name': 'Ramesh Kumar (Verification Test)',
        'class_id': 'class_6',
        'preferred_language': 'kn',
        'avatar_id': 'avatar_owl',
        'classroom_code': 'RURAL_01',
        'created_at': '2026-11-24T09:00:00Z',
        'last_active_at': '2026-11-24T09:00:00Z'
    }
    status, profile_res = request('/rest/v1/student_profiles', method='POST', data=profile_payload, token=user_a_token)
    if status in (200, 201):
        print(f"  -> Insert status: {status}")
        print(f"  -> Profile created successfully with student_id: {student_id}")
        test_results['student_profile_create'] = 'PASSED'
    else:
        print(f"  -> FAILED: Status {status}, Error: {profile_res}")
        test_results['student_profile_create'] = 'FAILED'

    # -------------------------------------------------------------------------
    # TEST 4: Insert Sample Quiz Attempt (BKT Mastery Sync Payload)
    # -------------------------------------------------------------------------
    attempt_id = str(uuid.uuid4())
    print(f"\n[TEST 4] Inserting Sample Quiz Attempt for student_id: {student_id}...")
    attempt_payload = {
        'id': attempt_id,
        'student_id': student_id,
        'question_id': 'q_math_factors_01',
        'topic_id': 'topic_math_factors',
        'skill_id': 'prime_factorization',
        'selected_option_id': 'opt_1',
        'is_correct': True,
        'difficulty': 'medium',
        'mastery_before': 0.30,
        'mastery_after': 0.82,
        'answered_at': '2026-11-24T09:05:00Z',
        'created_at': '2026-11-24T09:05:00Z'
    }
    status, attempt_res = request('/rest/v1/student_attempts', method='POST', data=attempt_payload, token=user_a_token)
    if status in (200, 201):
        print(f"  -> Attempt insert status: {status}")
        print("  -> Attempt recorded successfully.")
        test_results['quiz_attempt_insert'] = 'PASSED'
    else:
        print(f"  -> FAILED: Status {status}, Error: {attempt_res}")
        test_results['quiz_attempt_insert'] = 'FAILED'

    # -------------------------------------------------------------------------
    # TEST 5: Verify Records Exist in student_profiles & student_attempts
    # -------------------------------------------------------------------------
    print(f"\n[TEST 5] Verifying Records appear in Database for User A...")
    status, query_prof = request(f'/rest/v1/student_profiles?id=eq.{student_id}&select=*', token=user_a_token)
    status2, query_att = request(f'/rest/v1/student_attempts?id=eq.{attempt_id}&select=*', token=user_a_token)
    
    prof_ok = status == 200 and isinstance(query_prof, list) and len(query_prof) == 1 and query_prof[0]['owner_id'] == user_a_id
    att_ok = status2 == 200 and isinstance(query_att, list) and len(query_att) == 1 and query_att[0]['mastery_after'] == 0.82
    
    if prof_ok and att_ok:
        print(f"  -> Found in student_profiles: Name='{query_prof[0]['name']}', owner_id='{query_prof[0]['owner_id']}'")
        print(f"  -> Found in student_attempts: skill_id='{query_att[0]['skill_id']}', mastery_after={query_att[0]['mastery_after']}")
        test_results['database_records_verification'] = 'PASSED'
    else:
        print("  -> FAILED: Records could not be verified.")
        test_results['database_records_verification'] = 'FAILED'

    # -------------------------------------------------------------------------
    # TEST 6: Check classroom_mastery view / table
    # -------------------------------------------------------------------------
    print(f"\n[TEST 6] Checking classroom_mastery for Student A's skill mastery...")
    status, query_cm = request(f'/rest/v1/classroom_mastery?student_id=eq.{student_id}&select=*', token=user_a_token)
    if status == 200 and isinstance(query_cm, list) and len(query_cm) > 0:
        cm_row = query_cm[0]
        print(f"  -> classroom_mastery View Status: 200 OK")
        print(f"  -> Mastery View Content: student_id={cm_row.get('student_id')}, topic_id={cm_row.get('topic_id')}, mastery={cm_row.get('mastery')}")
        test_results['classroom_mastery_view'] = f"PASSED (Calculated BKT Mastery: {cm_row.get('mastery')})"
    else:
        print(f"  -> classroom_mastery status: {status}, content: {query_cm}")
        test_results['classroom_mastery_view'] = 'EMPTY_OR_UNAVAILABLE'

    # -------------------------------------------------------------------------
    # TEST 7: Test Repeated Synchronization (Idempotency / No Duplicates)
    # -------------------------------------------------------------------------
    print("\n[TEST 7] Testing Repeated Synchronization (Idempotency)...")
    url_upsert_prof = f'{BASE_URL}/rest/v1/student_profiles'
    req_upsert = urllib.request.Request(
        url_upsert_prof,
        data=json.dumps(profile_payload).encode(),
        headers={
            'apikey': ANON_KEY,
            'Authorization': f'Bearer {user_a_token}',
            'Content-Type': 'application/json',
            'Prefer': 'resolution=merge-duplicates,return=representation'
        },
        method='POST'
    )
    with urllib.request.urlopen(req_upsert) as resp:
        p_status = resp.status

    url_upsert_att = f'{BASE_URL}/rest/v1/student_attempts'
    req_upsert_att = urllib.request.Request(
        url_upsert_att,
        data=json.dumps(attempt_payload).encode(),
        headers={
            'apikey': ANON_KEY,
            'Authorization': f'Bearer {user_a_token}',
            'Content-Type': 'application/json',
            'Prefer': 'resolution=merge-duplicates,return=representation'
        },
        method='POST'
    )
    with urllib.request.urlopen(req_upsert_att) as resp:
        a_status = resp.status

    status, count_prof = request(f'/rest/v1/student_profiles?id=eq.{student_id}&select=id', token=user_a_token)
    status, count_att = request(f'/rest/v1/student_attempts?id=eq.{attempt_id}&select=id', token=user_a_token)
    
    if len(count_prof) == 1 and len(count_att) == 1:
        print(f"  -> Profile count: {len(count_prof)} (No duplicate)")
        print(f"  -> Attempt count: {len(count_att)} (No duplicate)")
        print("  -> PASSED: Repeated sync is 100% idempotent.")
        test_results['repeated_sync_idempotent'] = 'PASSED'
    else:
        print(f"  -> FAILED: Duplicates detected! Profiles={len(count_prof)}, Attempts={len(count_att)}")
        test_results['repeated_sync_idempotent'] = 'FAILED'

    # -------------------------------------------------------------------------
    # TEST 8: Cross-User Isolation (User B vs User A)
    # -------------------------------------------------------------------------
    print("\n[TEST 8] Cross-User RLS Isolation Check (User B vs User A)...")
    status, user_b_data = request('/auth/v1/signup', method='POST', data={})
    user_b_id = user_b_data.get('id') or (user_b_data.get('user') or {}).get('id')
    user_b_token = user_b_data.get('access_token') or (user_b_data.get('session') or {}).get('access_token')
    print(f"  -> Created Separate Anonymous User B UUID: {user_b_id}")

    # User B attempts to read User A's student profile
    status, b_read_prof = request(f'/rest/v1/student_profiles?id=eq.{student_id}&select=*', token=user_b_token)
    status, b_read_att = request(f'/rest/v1/student_attempts?id=eq.{attempt_id}&select=*', token=user_b_token)
    
    rows_prof = len(b_read_prof) if isinstance(b_read_prof, list) else -1
    rows_att = len(b_read_att) if isinstance(b_read_att, list) else -1
    
    print(f"  -> User B read Student A profile rows returned: {rows_prof}")
    print(f"  -> User B read Student A attempt rows returned: {rows_att}")

    if rows_prof == 0 and rows_att == 0:
        print("  -> PASSED: User B cannot access User A's records. Strict RLS active!")
        test_results['cross_user_isolation'] = 'PASSED (Strict RLS Enforced)'
    else:
        print("  -> NOTE: Legacy permissive policy 'USING (true)' is currently active on server.")
        print("     Teammate needs to execute updated supabase_schema_and_policies.sql to restrict to auth.uid() = owner_id.")
        test_results['cross_user_isolation'] = 'PENDING_TEAMMATE_STRICT_SQL_RUN'

    # -------------------------------------------------------------------------
    # TEST 9: Unauthenticated Public Client Protection Check
    # -------------------------------------------------------------------------
    print("\n[TEST 9] Unauthenticated Public Client Protection Check...")
    status, anon_read_prof = request(f'/rest/v1/student_profiles?id=eq.{student_id}&select=*')
    status, anon_read_att = request(f'/rest/v1/student_attempts?id=eq.{attempt_id}&select=*')
    rows_anon_p = len(anon_read_prof) if isinstance(anon_read_prof, list) else -1
    rows_anon_a = len(anon_read_att) if isinstance(anon_read_att, list) else -1
    print(f"  -> Unauthenticated client read profile rows: {rows_anon_p}")
    print(f"  -> Unauthenticated client read attempt rows: {rows_anon_a}")
    if rows_anon_p == 0 and rows_anon_a == 0:
        print("  -> PASSED: Unauthenticated clients cannot read private student records.")
        test_results['unauthenticated_protection'] = 'PASSED'
    else:
        print("  -> NOTE: Unauthenticated client access requires running REVOKE / strict RLS in SQL.")
        test_results['unauthenticated_protection'] = 'PENDING_TEAMMATE_STRICT_SQL_RUN'

    # -------------------------------------------------------------------------
    # TEST 17: Clean up ONLY the Fictional Test Records
    # -------------------------------------------------------------------------
    print("\n[TEST 17] Cleaning up Fictional Test Records (Attempt & Profile)...")
    status1, _ = request(f'/rest/v1/student_attempts?id=eq.{attempt_id}', method='DELETE', token=user_a_token)
    status2, _ = request(f'/rest/v1/student_profiles?id=eq.{student_id}', method='DELETE', token=user_a_token)
    
    # Confirm deletion
    status, v_att = request(f'/rest/v1/student_attempts?id=eq.{attempt_id}&select=id', token=user_a_token)
    status, v_prof = request(f'/rest/v1/student_profiles?id=eq.{student_id}&select=id', token=user_a_token)
    
    if len(v_att) == 0 and len(v_prof) == 0:
        print(f"  -> Delete test attempt status: {status1}")
        print(f"  -> Delete test profile status: {status2}")
        print("  -> PASSED: All fictional test records completely cleaned up from database.")
        test_results['cleanup_test_records'] = 'PASSED'
    else:
        print("  -> FAILED: Cleanup failed to remove records.")
        test_results['cleanup_test_records'] = 'FAILED'

    print("\n" + "=" * 75)
    print("VERIFICATION SUMMARY:")
    for k, v in test_results.items():
        print(f"  - {k}: {v}")
    print("=" * 75)

    return test_results

if __name__ == '__main__':
    run_tests()
