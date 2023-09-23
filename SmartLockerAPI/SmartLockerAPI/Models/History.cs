using System;
using System.Collections.Generic;

namespace SmartLocker.Models;

public partial class History
{
    public string HistoryId { get; set; } = null!;

    public string? UserId { get; set; }

    public string? LockerId { get; set; }

    public String? StartTime { get; set; }

    public String? EndTime { get; set; }

    public virtual Locker? Locker { get; set; }

    public virtual User? User { get; set; }
}
