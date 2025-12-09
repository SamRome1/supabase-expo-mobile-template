-- Create storage bucket for entries
INSERT INTO storage.buckets (id, name, public)
VALUES ('entries', 'entries', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policy: Users can upload their own files
CREATE POLICY "Users can upload own files"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'entries' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Storage policy: Users can view all files in entries bucket
CREATE POLICY "Anyone can view entries"
ON storage.objects FOR SELECT
USING (bucket_id = 'entries');

-- Storage policy: Users can delete their own files
CREATE POLICY "Users can delete own files"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'entries' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

