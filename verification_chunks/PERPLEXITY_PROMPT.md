# Perplexity AI Source Verification Prompt

## How to use

1. Open Perplexity AI (Pro recommended for larger context)
2. Paste the prompt below
3. Attach one chunk file at a time (chunk_01.txt through chunk_09.txt)
4. Collect the results from each chunk
5. Repeat for all 9 chunks

---

## Prompt (copy this exactly):

```
You are verifying survival/first-aid technique content for an app submission. I will give you a list of techniques. Each has:
- ID
- NAME
- SOURCE (a URL)
- STEPS (numbered instructions)

YOUR JOB:

For EACH technique:
1. Visit/search the SOURCE URL
2. Read what that page actually says
3. Compare the technique's STEPS against what the source page teaches
4. Rate it:
   - ✅ VERIFIED — steps match or accurately paraphrase the source content
   - ⚠️ IMPRECISE URL — steps are real/correct survival advice but the URL points to a homepage or general page, not the specific article. Suggest a better URL if you can find one.
   - ❌ MISMATCH — steps contradict or are NOT found in the cited source
   - 📚 BOOK — source is a book ISBN/reference, not a webpage. Confirm the book exists and is a real published survival/medical reference.

For imprecise URLs (⚠️), search for the CORRECT specific page URL on that same website that matches the technique content, and provide it.

OUTPUT FORMAT (for each technique):
ID: [technique id]
STATUS: [✅/⚠️/❌/📚]
CURRENT URL: [current source url]
CORRECT URL: [better url if found, or "same" if current is good]
NOTES: [brief explanation]

Focus on accuracy. Do not fabricate URLs. If you cannot find a matching page, say so.

Here is the data:
```

---

## Chunk files

| File | Techniques | Size |
|---|---|---|
| chunk_01.txt | 194 | 77KB |
| chunk_02.txt | 105 | 39KB |
| chunk_03.txt | 257 | 114KB |
| chunk_04.txt | 209 | 84KB |
| chunk_05.txt | 158 | 58KB |
| chunk_06.txt | 200 | 78KB |
| chunk_07.txt | 134 | 48KB |
| chunk_08.txt | 169 | 65KB |
| chunk_09.txt | 103 | 42KB |
| **Total** | **1,529** | **605KB** |
