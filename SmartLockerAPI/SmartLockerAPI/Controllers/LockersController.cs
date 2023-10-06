using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartLocker.Data;
using SmartLocker.Models;

namespace SmartLockerAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LockersController : ControllerBase
    {
        private readonly SmartLockerContext _context;

        public LockersController(SmartLockerContext context)
        {
            _context = context;
        }

        // GET: api/Lockers
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Locker>>> GetLockers()
        {
          if (_context.Lockers == null)
          {
              return NotFound();
          }
            return await _context.Lockers.ToListAsync();
        }

        // GET: api/Lockers/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Locker>> GetLocker(string id)
        {
          if (_context.Lockers == null)
          {
              return NotFound();
          }
            var locker = await _context.Lockers.FindAsync(id);

            if (locker == null)
            {
                return NotFound();
            }

            return locker;
        }

        // PUT: api/Lockers/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutLocker(string id, Locker locker)
        {
            if (id != locker.LockerId)
            {
                return BadRequest();
            }

            _context.Entry(locker).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LockerExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Lockers
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Locker>> PostLocker(Locker locker)
        {
          if (_context.Lockers == null)
          {
              return Problem("Entity set 'SmartLockerContext.Lockers'  is null.");
          }
            _context.Lockers.Add(locker);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (LockerExists(locker.LockerId))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetLocker", new { id = locker.LockerId }, locker);
        }

        // DELETE: api/Lockers/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLocker(string id)
        {
            if (_context.Lockers == null)
            {
                return NotFound();
            }
            var locker = await _context.Lockers.FindAsync(id);
            if (locker == null)
            {
                return NotFound();
            }

            _context.Lockers.Remove(locker);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool LockerExists(string id)
        {
            return (_context.Lockers?.Any(e => e.LockerId == id)).GetValueOrDefault();
        }
    }
}
