using System;
using System.Threading;
using System.Threading.Tasks;

namespace DoubleFreeTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            CancellationTokenSource cts = new CancellationTokenSource();

            Console.CancelKeyPress += (sender, eventArgs) =>
            {
                eventArgs.Cancel = true;
                cts.Cancel();
            };

            var tasks = new Task[]
            {
                TestAsync(cts.Token),
                TestAsync(cts.Token),
                TestAsync(cts.Token),
                TestAsync(cts.Token),
                TestAsync(cts.Token),
                TestAsync(cts.Token),
                TestAsync(cts.Token),
            };

            Console.WriteLine("Running...");

            Task.WaitAll(tasks);
        }

        private static async Task TestAsync(CancellationToken cancellationToken)
        {
            try
            {
                while (!cancellationToken.IsCancellationRequested)
                {
                    await Task.Delay(TimeSpan.FromSeconds(5), cancellationToken);

                    Console.Write(".");
                }
            }
            catch (TaskCanceledException)
            {
            }
        }


    }
}
