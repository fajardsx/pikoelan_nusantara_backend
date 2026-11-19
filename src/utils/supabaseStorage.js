const { createClient } = require('@supabase/supabase-js');
const { v4: uuidv4 } = require('uuid');
const path = require('path');

// Pakai Service Role Key (bukan anon key) - ini jalan di server, butuh izin
// tulis ke bucket tanpa terikat RLS policy milik user biasa.
// JANGAN PERNAH pakai service role key ini di kode frontend/browser.
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const bucketName = process.env.SUPABASE_STORAGE_BUCKET || 'uploads';

let supabase = null;
if (supabaseUrl && supabaseServiceKey) {
  supabase = createClient(supabaseUrl, supabaseServiceKey);
} else {
  console.warn('⚠️  SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY belum diisi di .env - upload gambar akan gagal.');
}

// Upload buffer file (dari multer memoryStorage) ke Supabase Storage.
// folder: 'menu' | 'profiles' - dipakai untuk mengelompokkan file di dalam bucket.
// Mengembalikan URL publik yang langsung bisa dipakai di <img src>.
const uploadFile = async (buffer, originalName, mimetype, folder) => {
  if (!supabase) {
    throw new Error('Supabase Storage belum dikonfigurasi. Lengkapi SUPABASE_URL dan SUPABASE_SERVICE_ROLE_KEY di .env');
  }

  const fileName = `${uuidv4()}${path.extname(originalName)}`;
  const filePath = `${folder}/${fileName}`;

  const { error } = await supabase.storage.from(bucketName).upload(filePath, buffer, {
    contentType: mimetype,
    upsert: false,
  });

  if (error) {
    throw new Error(`Gagal upload ke Supabase Storage: ${error.message}`);
  }

  const { data } = supabase.storage.from(bucketName).getPublicUrl(filePath);
  return { publicUrl: data.publicUrl, path: filePath };
};

// Hapus file lama dari Supabase Storage berdasarkan URL publiknya.
// Diam-diam gagal (tidak throw) supaya operasi utama (mis. update item) tidak
// ikut gagal cuma gara-gara file lama gagal dihapus.
const deleteFile = async (publicUrl) => {
  if (!supabase || !publicUrl) return;

  const marker = `/storage/v1/object/public/${bucketName}/`;
  const idx = publicUrl.indexOf(marker);
  if (idx === -1) return; // bukan URL Supabase Storage (mungkin data lama), lewati saja

  const filePath = publicUrl.slice(idx + marker.length);
  const { error } = await supabase.storage.from(bucketName).remove([filePath]);
  if (error) {
    console.warn('Gagal menghapus file lama dari Supabase Storage:', error.message);
  }
};

module.exports = { uploadFile, deleteFile };
