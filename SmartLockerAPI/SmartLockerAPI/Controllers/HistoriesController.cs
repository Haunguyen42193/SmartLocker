﻿using System;
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
    public class HistoriesController : ControllerBase
    {
        private readonly SmartLockerContext _context;

        public HistoriesController(SmartLockerContext context)
        {
            _context = context;
        }

        // GET: api/Histories
        [HttpGet]
        public async Task<ActionResult<IEnumerable<History>>> GetHistories()
        {
            List<History> histories = new List<History>();
            histories = _context.Histories.ToList();
          if (_context.Histories == null)
          {
              return NotFound();
          }
            return histories;
        }

        // GET: api/Histories/5
        [HttpGet("{id}")]
        public async Task<ActionResult<History>> GetHistory(string id)
        {
          if (_context.Histories == null)
          {
              return NotFound();
          }
            var history = await _context.Histories.FindAsync(id);

            if (history == null)
            {
                return NotFound();
            }

            return history;
        }

        // PUT: api/Histories/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHistory(string id, History history)
        {
            if (id != history.HistoryId)
            {
                return BadRequest();
            }

            _context.Entry(history).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!HistoryExists(id))
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

        // POST: api/Histories
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<History>> PostHistory(HistoryData data)
        {
            if (_context.Histories == null)
            {
                return Problem("Entity set 'SmartLockerContext.Histories'  is null.");
            }
            if(data == null)
            {
                return BadRequest();
            }    
            if(data.HistoryId == null)
            {
                return BadRequest();
            } 
            History history = _context.Histories.Find(data.HistoryId);
            if(history == null)
            {
                return NotFound(data);
            }    
            history.Receiver = data.Receiver;
            history.UserSend = data.UserSend;
            history.Shipper = data.Shipper;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (HistoryExists(history.HistoryId))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }
            return CreatedAtAction("GetHistory", new { id = history.HistoryId }, history);
        }

        // DELETE: api/Histories/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHistory(string id)
        {
            if (_context.Histories == null)
            {
                return NotFound();
            }
            var history = await _context.Histories.FindAsync(id);
            if (history == null)
            {
                return NotFound();
            }
            history.Receiver = null;
            history.UserSend = null;
            history.Shipper = null;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool HistoryExists(string id)
        {
            return (_context.Histories?.Any(e => e.HistoryId == id)).GetValueOrDefault();
        }
        public class HistoryData
        {
            public string? HistoryId { get; set; }
            public string? UserSend { get; set; }
            public string? Shipper { get; set; }
            public string? Receiver { get; set; }
        }
    }
}