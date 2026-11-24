-- ==============================================================================
-- ShikshaEdge (TEAMAPEX) — Production Supabase RLS & Strict Security Policies
-- ==============================================================================
-- Exactly 8 Active Granular Security Policies:
-- 1. classrooms:
--    - "Teachers read own classrooms" (SELECT)
-- 2. classroom_students:
--    - "Teachers read own memberships" (SELECT)
-- 3. student_profiles:
--    - "Students insert own profiles" (INSERT)
--    - "Students read own profiles" (SELECT)
--    - "Students update own profiles" (UPDATE)
--    - "Teachers read enrolled students" (SELECT)
-- 4. student_attempts:
--    - "Students insert own attempts" (INSERT)
--    - "Read authorized student attempts" (SELECT)
--
-- Unrestricted / permissive policies have been completely removed.
-- Unauthenticated (anon) table access is revoked.
-- ==============================================================================

-- 1. Ensure Table Privileges for Authenticated and Service Role
REVOKE ALL ON TABLE public.student_profiles FROM anon;
REVOKE ALL ON TABLE public.student_attempts FROM anon;
REVOKE ALL ON TABLE public.classrooms FROM anon;
REVOKE ALL ON TABLE public.classroom_students FROM anon;

GRANT USAGE ON SCHEMA public TO authenticated, service_role;
GRANT ALL ON TABLE public.student_profiles TO authenticated, service_role;
GRANT ALL ON TABLE public.student_attempts TO authenticated, service_role;
GRANT ALL ON TABLE public.classrooms TO authenticated, service_role;
GRANT ALL ON TABLE public.classroom_students TO authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated, service_role;

-- 2. Ensure Row Level Security is Enabled on All Tables
ALTER TABLE public.student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classrooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classroom_students ENABLE ROW LEVEL SECURITY;

-- 3. student_profiles Policies
DROP POLICY IF EXISTS "Students insert own profiles" ON public.student_profiles;
CREATE POLICY "Students insert own profiles"
  ON public.student_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Students read own profiles" ON public.student_profiles;
CREATE POLICY "Students read own profiles"
  ON public.student_profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Students update own profiles" ON public.student_profiles;
CREATE POLICY "Students update own profiles"
  ON public.student_profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = owner_id)
  WITH CHECK (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Teachers read enrolled students" ON public.student_profiles;
CREATE POLICY "Teachers read enrolled students"
  ON public.student_profiles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.classroom_students
      JOIN public.classrooms ON classrooms.id = classroom_students.classroom_id
      WHERE classroom_students.student_id = student_profiles.id
        AND classrooms.teacher_id = auth.uid()
    )
  );

-- 4. student_attempts Policies
DROP POLICY IF EXISTS "Students insert own attempts" ON public.student_attempts;
CREATE POLICY "Students insert own attempts"
  ON public.student_attempts
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.student_profiles
      WHERE student_profiles.id = student_attempts.student_id
        AND student_profiles.owner_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Read authorized student attempts" ON public.student_attempts;
CREATE POLICY "Read authorized student attempts"
  ON public.student_attempts
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles
      WHERE student_profiles.id = student_attempts.student_id
        AND (
          student_profiles.owner_id = auth.uid()
          OR EXISTS (
            SELECT 1 FROM public.classroom_students
            JOIN public.classrooms ON classrooms.id = classroom_students.classroom_id
            WHERE classroom_students.student_id = student_profiles.id
              AND classrooms.teacher_id = auth.uid()
          )
        )
    )
  );

-- 5. classrooms Policies
DROP POLICY IF EXISTS "Teachers read own classrooms" ON public.classrooms;
CREATE POLICY "Teachers read own classrooms"
  ON public.classrooms
  FOR SELECT
  TO authenticated
  USING (auth.uid() = teacher_id);

-- 6. classroom_students Policies
DROP POLICY IF EXISTS "Teachers read own memberships" ON public.classroom_students;
CREATE POLICY "Teachers read own memberships"
  ON public.classroom_students
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.classrooms
      WHERE classrooms.id = classroom_students.classroom_id
        AND classrooms.teacher_id = auth.uid()
    )
  );

-- 7. Verification Query
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles, 
  cmd 
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
